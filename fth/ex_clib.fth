anew task-ex_clib.fth

\ HERE WILL BE WORDSETS...

\ \ \ \ \ \ \ \
\ VARS/BUFFERS \
\ \ \ \ \ \ \ \ \
0 value lib-fileid
create lib-name 64 chars allot
0 value lib-name-len

unix? [if]
  s" echo $HOME/.exforth/" sh-get
  1 - \ newline
  dup constant lib-name-base-len
  lib-name swap move

[else]
  \ TODO: HERE WILL BE WINDOWS STUFF
[then]

\ \ \ \ \
\ SETUP \
\ \ \ \ \
: lib-name! ( c-addr1 u1 -- )
  dup lib-name-base-len + -rot
  \ add the name
  lib-name lib-name-base-len chars + swap move
  \ add extension
  dup
  s" .c" rot chars lib-name + swap move
  \ return
  2 + to lib-name-len
;


: lib-begin ( -- )
  lib-fileid dup
  s" #define C_RETURNS_VOID  (0)"
  rot write-line throw dup
  s" #define C_RETURNS_VALUE (1)"
  rot write-line throw dup
  s" typedef void (*addFunction_t)(void* fn, char* name, int argsNum, int returns);"
  rot write-line throw dup
  s" typedef intptr_t cell_t;"
  rot write-line throw dup
  s" void addWords(void* fn) { // }"
  rot write-line throw
  s" addFunction_t addFunction = (addFunction_t) fn;"
  rot write-line throw
;

: lib-end ( -- )
  s" }" lib-fileid write-line throw ;

\ HERE WILL BE FORTH...

: c-library ( "name" -- )
  unix? if
    s" mkdir ~/.exforth 2> /dev/null" system
  else
    ." win not supported"
    \ TODO: HERE WILL BE WINDOWS STUFF
  then

  parse-name lib-name!
  \ TODO: check if source newer
  lib-name lib-name-len R/W create-file throw to lib-fileid
  lib-begin
;

: end-c-library ( -- )
  lib-fileid dup 0= if drop else
    dup lib-end
    close-file throw
  then ;

