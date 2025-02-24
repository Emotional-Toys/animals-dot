\ Motion detection on internal node
variable prev-mag  \ Store previous magnitude for change detection
0 prev-mag !      \ Initialize to 0

: sq  \ Square a number (x -- x²)
  dup *  
;

: magnitude  \ Calculate sqrt(x² + y² + z²) (x y z -- mag)
  sq rot sq + rot sq +  \ x² + y² + z²
  \ Simplified sqrt approximation (basic for demo, refine as needed)
  dup 2 / +  \ Rough integer sqrt (e.g., Newton's method stub)
;

: detect-motion  \ Check for significant motion (x y z -- flag)
  magnitude  \ Get current magnitude
  prev-mag @  \ Get previous magnitude
  swap - abs  \ Calculate change (absolute difference)
  100 >       \ Threshold (e.g., >100 for significant motion, adjust based on units)
  if
    1         \ Motion detected (true)
  else
    0         \ No motion (false)
  then
  dup prev-mag !  \ Update previous magnitude
;

\ Usage example: read-accel detect-motion  \ Returns 1 if motion detected, 0 otherwise