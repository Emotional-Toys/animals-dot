\ I2C setup for LIS3DH on GA144 (edge node)
: lis3dh-init  \ Initialize LIS3DH
  0x18 i2c-start  \ Start I2C with device address (0x18)
  0x20 i2c-write  \ Write to CTRL_REG1 register
  0x57 i2c-write  \ Set to 100Hz, normal mode, all axes enabled
  i2c-stop        \ End transaction
;

: read-accel  \ Read 6 bytes (x, y, z acceleration) from LIS3DH
  0x18 i2c-start
  0x28 i2c-write  \ Start at OUT_X_L register with auto-increment
  i2c-stop
  0x18 i2c-start  \ Restart for reading
  1 i2c-read      \ Read low byte of x
  256 *           \ Shift left 8 bits
  1 i2c-read      \ Read high byte of x
  +               \ Combine for 16-bit x
  1 i2c-read      \ Low byte of y
  256 *           \ Shift left 8 bits
  1 i2c-read      \ High byte of y
  +               \ Combine for 16-bit y
  1 i2c-read      \ Low byte of z
  256 *           \ Shift left 8 bits
  1 i2c-read      \ High byte of z
  +               \ Combine for 16-bit z
  i2c-stop        \ End transaction
  \ Stack now holds: x y z (16-bit values)
;