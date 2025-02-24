\ Edge node: Read and distribute data
: distribute-data  \ Read accel, send to internal nodes
  read-accel      \ Get x y z
  1 node!         \ Send x to node 1
  2 node!         \ Send y to node 2
  3 node!         \ Send z to node 3
  \ Nodes 1–3 run detect-motion in parallel
;

\ Internal node 1 (process x, similar for y, z on other nodes)
: process-x  
  node@           \ Receive x from edge
  0 0 rot         \ Pad with 0s for y, z (simplified)
  detect-motion   \ Check motion
  if
    4 node!       \ Signal motion to output node (e.g., node 4)
  then
;