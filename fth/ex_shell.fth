anew task-ex_shell.fth

0 value $?
create sh$ 0 , 0 ,

: system ( c-addr u -- ) \ sets $?
  (system) to $? ;

: sh-get ( c-add u -- c-addr2 u2 ) \ sets $? sh$
  (sh-get) to $?
  2dup
  sh$ !
  sh$ 1 cells + !
;

: sh ( "..." -- ) \ sets $?
  parse-line system ;
