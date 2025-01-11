anew task-ex_parse.fth

: PARSE-NAME ( "name" -- c-addr u)
  bl lword count ;

: PARSE-LINE ( <line> -- c-addr u )
  10 parse ;
