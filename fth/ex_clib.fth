anew task-ex_clib.fth

\ TODO: add some checks!
\ TODO: do something with types (be able to take and return to float stack)

private{

\ \ \ \ \ \ \ \
\ VARS/BUFFERS \
\ \ \ \ \ \ \ \ \

0 value lib-fileid
create lib-name 64 allot
create lib-name-len 0 ,
: lib-name@ ( -- c-addr u )
  lib-name lib-name-len @ ;

unix? [if]
  s" echo $HOME/.exforth/" sh-get
    1 - \ newline
    dup constant lib-name-base-len
    lib-name swap move
[else]
  \ TODO: HERE WILL BE WINDOWS STUFF
[then]
lib-name-base-len lib-name-len !

create c-name-str 32 allot
create c-name-len 0 ,
: c-name@ ( -- c-addr u )
  c-name-str c-name-len @ ;

create forth-name-str 32 allot
create forth-name-len 0 ,
: forth-name@ ( -- c-addr u )
  forth-name-str forth-name-len @ ;

create compile-command 256 allot
create compile-command-len 0 ,
: compile-command@ ( -- c-addr u )
  compile-command compile-command-len @ ;

create addWords-body 1024 allot
create addWords-body-len 0 ,
: addWords-body@ ( -- c-addr u ) 
  addWords-body addWords-body-len @ ;

create temp-words 1024 allot
create temp-words-len 0 ,
: temp-words@ ( -- c-addr u ) 
  temp-words temp-words-len @ ;

\ return types
0 constant void
1 constant n
3 constant d
4 constant r
5 constant s

\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
\ BUFFER SPECIFIC MANIPULATION \
\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \

: buff-write ( c-addr u buff-addr buff-len-addr -- )
  rot dup rot +!
  move ;

: addWords-write ( c-addr u -- )
  addWords-body@ + addWords-body-len buff-write ;

: addWords-write-line ( c-addr u -- )
  addWords-write
  s\" \n" addWords-write ;

: temp-words-write ( c-addr u -- )
  temp-words@ + temp-words-len buff-write ;

s" void addWords(void* fn) {"
addWords-write-line
s" addFunction_t addFunction = (addFunction_t) fn;"
addWords-write-line
addWords-body-len @ constant addWords-body-base-len

\ \ \ \ \ \
\ FILE OPS \
\ \ \ \ \ \ \

: lib-write ( c-addr u -- )
  lib-fileid write-file throw ;

: lib-write-line ( c-addr u -- )
  lib-fileid write-line throw ;

\ \ \ \ \
\ SETUP \
\ \ \ \ \

: reset-lib ( -- )
  0 c-name-len !
  0 to lib-fileid
  0 forth-name-len !
  0 temp-words-len !
  0 compile-command-len !
  lib-name-base-len lib-name-len !
  addWords-body-base-len addWords-body-len !
;

: lib-name! ( c-addr1 u1 -- )
  dup -rot
  \ add the name
  lib-name@ + swap move
  \ add extension
  lib-name-len +!
  s" .c" lib-name@ + swap move
  \ return
  2 lib-name-len +!
;


: lib-begin ( -- )
  s" #include <stdint.h>"
  lib-write-line
  s" #define C_RETURNS_VOID  (0)"
  lib-write-line
  s" #define C_RETURNS_VALUE (1)"
  lib-write-line
  s" typedef void (*addFunction_t)(void* fn, char* name, int argsNum, int returns);"
  lib-write-line
  s" typedef intptr_t cell_t;"
  lib-write-line
;

: lib-end ( -- )
  s" }" addWords-write
  addWords-body@ lib-write-line ;

\ \ \ \ \ \ \ \ \
\ COMPILE STUFF \
\ \ \ \ \ \ \ \ \

: command-write ( c-addr u -- )
  dup -rot
  compile-command@ + swap move
  +to compile-command-len
;

: command-begin ( -- )
  s" gcc -fPIC -shared " command-write
  lib-name@ command-write
  s"  -o " command-write
  lib-name@ 2 - command-write
  s" .so" command-write
;

\ \ \ \ \ \ \ \ \
\ LIB FILE STUFF \
\ \ \ \ \ \ \ \ \ \

: forth-name! ( c-addr u -- )
  dup forth-name-len !
  forth-name-str swap move ;

: c-name! ( c-addr u -- )
  dup c-name-len !
  c-name-str swap move ;

: set-forth&c-names ( "forth-name" "c-name" -- )
  parse-name forth-name!
  parse-name c-name! ;

: write-lib-wrap-name ( -- )
  c-name@ lib-write s" _FTH_INCLUDE" lib-write ;

: write-addWords-wrap-name ( -- )
  c-name@ addWords-write s" _FTH_INCLUDE" addWords-write ;

\ : write-value-func ( -- )
\   s" static cell_t " lib-write
\   write-wrap-name s" () { return (cell_t)" lib-write
\   c-name@ lib-write s" ; }" lib-write-line
\ ;

: write-variable-func ( -- )
  s" static cell_t " lib-write
  write-lib-wrap-name s" () { return (cell_t)&" lib-write
  c-name@ lib-write s" ; }" lib-write-line
;

: write-bind-func ( n n -- ) \ type arg-num
  s" addFunction(&" addWords-write write-addWords-wrap-name
  s\" , \"" addWords-write forth-name@ addWords-write
  s\" \", " addWords-write s>d <# #s #> addWords-write
  s" , " addWords-write
  case
    void of
      s" C_RETURNS_VOID"
    endof
    s" C_RETURNS_VALUE"
    rot
  endcase
  addWords-write
  s" );" addWords-write-line
;

: str>type ( c-addr u -- n )
  drop
  case
    dup s" void" swap text= ?of void endof
    n
  endcase
  drop
;

}private

\ HERE WILL BE WORDSET...

\ \ \ \ \ \ \ \ \
\ USER CALLABLE \
\ \ \ \ \ \ \ \ \

: \c ( "..." -- )
  parse-line lib-write-line ;

: c-function ( "forth-name" "c-name" "{type}" "--" "type" -- )
  set-forth&c-names
;

\ : c-value ( "forth-name" "c-name" "--" "type" -- )
\   set-forth&c-names
\   write-value-func
\   parse-name 2drop parse-name str>type 0 write-bind-func
\ ;

: c-variable ( "forth-name" "c-name" -- )
  set-forth&c-names
  write-variable-func
  n 0 write-bind-func
;

\ \ \ \ \ \ \ \ \
\ USER INTERFACE \
\ \ \ \ \ \ \ \ \ \

\ HERE WILL BE FORTH...

: c-library-name ( c-addr u -- )
  \ TODO: check if already compiled
  reset-lib
  unix? if
    s" mkdir ~/.exforth 2> /dev/null" system
  else
    ." win not supported"
    \ TODO: HERE WILL BE WINDOWS STUFF
  then

  lib-name!
  \ TODO: check if source newer
  lib-name@ R/W create-file throw to lib-fileid
  lib-begin
  command-begin
;

: c-library ( "name" -- )
  parse-name c-library-name ;

: end-c-library ( -- )
  lib-end
  lib-fileid close-file throw

  compile-command@ system
  \ I don't know if I like or hate this hack
  s" so" lib-name@ 1- + swap move
  lib-name@ 1+ include-clib
;

privatize
