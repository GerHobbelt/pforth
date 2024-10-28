anew task-ex_parse.sh

: parse-name ( n1 "name" -- c-addr u)
  bl lword count ;

: parse-line ( -- c-addr u )
  10 parse ;
