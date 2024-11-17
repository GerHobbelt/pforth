anew task-ex_shell.fth

0 value $?
create sh$ 0 , 0 ,

: SYSTEM ( c-addr u -- ) \ sets $?
  (system) to $? ;

: SH-GET ( c-add u -- c-addr2 u2 ) \ sets $? sh$
  (sh-get) to $?
  2dup
  sh$ !
  sh$ 1 cells + !
;

: SH ( "..." -- ) \ sets $?
  parse-line system ;

\ TODO: windows support fro env vars
unix? [if]
: GETENV ( c-addr1 u1 -- c-addr2 u2 )
  swap over pad 6 + swap move
  s" echo $" pad swap move
  6 + pad swap sh-get
;

\ add .local/share/exforth to (INCLUDE-PREFIXES)
:noname ( -- c-addr u )
  s\" echo \"$HOME/.local/share/exforth/\"" sh-get 1- ; \ newline
(include-prefixes) 1 cells + !
[then]
