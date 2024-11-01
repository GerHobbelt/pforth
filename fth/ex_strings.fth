anew task-ex_strings.fth

: fth>c ( c-addr1 u1 -- c-addr2 )
  dup pad + 0 swap !
  pad swap move ;

: c>fth ( c-addr -- c-addr u )
  0
  begin 2dup + @ 0<> while 1+ repeat ;
