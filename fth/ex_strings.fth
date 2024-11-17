anew task-ex_strings.fth

: FTH>C ( c-addr1 u1 -- c-addr2 )
  \ 1+ because s" in REPL places there for some reason
  dup pad 1+ + 0 swap c!
  pad 1+ swap move
  pad 1+
;

: C>FTH ( c-addr -- c-addr u )
  0
  begin 2dup + c@ 0<> while 1+ repeat ;
