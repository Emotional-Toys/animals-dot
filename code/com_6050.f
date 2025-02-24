\ I2C setup for MPU-6050 on GA144 (edge node)
: mpu-init  \ Initialize MPU-6050
  0x68 i2c-start  \ Start I2C with device address (0x68)
  0x6B i2c-write  \ Write to PWR_MGMT_1 register
  0 i2c-write     \ Set to wake up (disable sleep)
  i2c-stop        \ End transaction
;

: read-accel  \ Read 6 bytes (x, y, z acceleration) from MPU-6050
  0x68 i2c-start
  0x3B i2c-write  \ Start at ACCEL_XOUT_H register
  i2c-stop
  0x68 i2c-start  \ Restart for reading
  1 i2c-read      \ Read high byte of x
  256 *           \ Shift left 8 bits
  1 i2c-read      \ Read low byte of x
  +               \ Combine for 16-bit x
  1 i2c-read      \ High byte of y
  256 *           \ Shift left 8 bits
  1 i2c-read      \ Low byte of y
  +               \ Combine for 16-bit y
  1 i2c-read      \ High byte of z
  256 *           \ Shift left 8 bits
  1 i2c-read      \ Low byte of z
  +               \ Combine for 16-bit z
  i2c-stop        \ End transaction
  \ Stack now holds: x y z (16-bit values)
;