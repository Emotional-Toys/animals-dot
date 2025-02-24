## Notes regarding the code files in this folder

### Communication between GA144 and MPU6050

This code runs on an edge node to initialize the MPU-6050 accelerometer and read acceleration data. The MPU-6050’s default I2C address is 0x68, and we’ll read the 6-byte acceleration register (0x3B–0x40 for x, y, z axes, 16-bit values).

_Explanation_ 

* `mpu-init` wakes up the MPU-6050 by writing to its power management register.
* `read-accel` reads 6 bytes (2 per axis) to get 16-bit acceleration values for x, y, z, leaving them on the stack.
* This runs on an edge node with I2C hardware, using GA144’s software-defined I/O. Adjust I2C pin assignments based on your board layout (e.g., pins 1, 2 for SDA, SCL, as per GreenArrays schematics).

### Motion detection Algorithm

This code runs on internal cores to analyze acceleration data for motion patterns (e.g., detecting shaking by monitoring acceleration magnitude changes). We’ll calculate the magnitude `sqrt(x² + y² + z²)` and compare it to a threshold.

_Explanation_

* `sq` squares a number (used for magnitude calculation).
* `magnitude` approximates the acceleration magnitude using a simple sum of squares, with a basic sqrt approximation (refine with more precise math if needed, though GA144’s limited memory favors simplicity).
* `detect-motion` compares the current magnitude to the previous one, flagging significant changes (e.g., shaking) if the difference exceeds a threshold (100, in arbitrary units—adjust based on MPU-6050 output, typically ±2g or ±4g range).
* This runs on an internal node, receiving x, y, z data from an edge node via inter-core communication (e.g., “bucket brigade” or shared memory, as per GA144’s architecture).

### Parallel Processing Across Cores

The GA144’s 144 cores allow distributing tasks. Here’s how to split work (code file).

_Explanation_
* `distribute-data` reads acceleration and sends x, y, z to different internal nodes for parallel processing, leveraging the GA144’s grid topology.
* `process-x` (and similar for y, z) runs `detect-motion` on each axis, aggregating results to an output node (e.g., to trigger a response like a sound).
Inter-core communication uses GA144’s node-to-node links, typically via `node!` and `node@` (simplified here—actual syntax depends on arrayForth).

### Response Trigger (Output Node)

Once motion is detected, trigger a toy response, e.g., play a sound via a speaker (code file).

_Explanation_
* `check-response` monitors motion detection flags from processing nodes, triggering an I2C command to activate a speaker or LED (simplified—adjust for your hardware).
* This runs on another edge node with I/O capabilities.

### Notes and Limitations

* Memory Constraints: Each core’s 64-word RAM/ROM limits complex algorithms. The above code is minimalist—expand `magnitude` or `detect-motion` with lookup tables or more precise math if needed, but keep within memory limits.
* I2C/SPI Implementation: Actual I2C words (`i2c-start`, `i2c-write`, etc.) vary by arrayForth version. Refer to GreenArrays’ documentation or community code (e.g., GitHub’s ga144tools) for exact syntax and pin assignments.
* Testing: Test with real MPU-6050 data to tune thresholds (e.g., 100 in `detect-motion`) based on g-force units (typically ±2g or ±4g for the MPU-6050, scaled to 16-bit values).
* Parallelism: The GA144’s asynchronous nature means timing isn’t guaranteed—use `wait` or `sync` primitives (if available in arrayForth) to coordinate cores if needed.
* Development Tools: Use arrayForth 3’s simulator or an evaluation board (e.g., EVB002) to test. Debugging is an open topic.

### How This Fits the Emotion-Recognizing Toy

* The code detects motion (e.g., shaking for excitement, rocking for calmness) using the accelerometer, complementing microphone-based vocal analysis.
* The GA144’s parallelism processes x, y, z data simultaneously, while low power ensures long battery life, aligning with the “least cost” and “maximum impact” goals for investment.
* Responses (e.g., sounds, lights) enhance play value, supporting emotional learning as discussed earlier.

### Comments

Synching is best done by simply waiting for port communication, which is necessary anyway.  If sending another node plain data send the numbers; if sending coded functions or commands, the best way to encode the functions is as instructions to be executed (e.g. call to routine in RAM.)  I work in quadrature, to avoid square roots, when feasible.  If you look at `AN012` you will see an example of `I2C` support, 3-axis accelerometer reading, and lowpass filtering. Regret that it uses `colorForth`; I hadn't made `aF-3` yet when we did that `AN012` work was done immediately after arriving.

Check [here](https://www.adafruit.com/product/2809)