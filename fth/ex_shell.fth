0 value $?
create sh$ 0 , 0 ,

: system ( c-addr u -- )
  system-inner to $? ;

: sh-get ( c-add u -- c-addr2 u2 ) \ sets $? sh$
  sh-get-inner to $?
  2dup
  sh$ !
  sh$ 1 cells + !
;
