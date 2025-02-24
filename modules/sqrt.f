0    ( 30-bit Square Root of a 60-bit integer)
1 CODE SQRT ( d - i)   2 POP   0 POP   I PUSH
2    W W SUB   W I MOV  32 # 1 MOV   BEGIN
3       0 SHL   2 RCL   I RCL   0 SHL   2 RCL   I RCL
4       W SHL   W SHL   W INC   W I CMP   CS NOT IF
5          W I SUB   W INC   THEN   W SHR   LOOP
6    I POP   W PUSH   NEXT
7
8 : SQRT. ( f - f)   +1 M* SQRT ;