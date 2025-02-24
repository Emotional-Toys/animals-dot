\ Output node (e.g., node 4)
variable motion-flag  0 motion-flag !

: check-response  
  node@           \ Receive motion flag from processing nodes
  motion-flag !   \ Update flag
  motion-flag @   \ Check if motion detected
  if
    0xFF i2c-write  \ Send command to speaker/LED (e.g., via I2C)
  then
;

\ Run continuously: check-response