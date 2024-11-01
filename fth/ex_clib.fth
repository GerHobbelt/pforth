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

create addWords-body 2048 allot \ ~ 25 funcs?
create addWords-body-len 0 ,
: addWords-body@ ( -- c-addr u ) 
  addWords-body addWords-body-len @ ;

create wrap-words 3400 allot
create wrap-words-len 0 ,
: wrap-words@ ( -- c-addr u ) 
  wrap-words wrap-words-len @ ;

create wrap-args 512 allot \ I support up to 15 args, so it can get quite long
create wrap-args-len 0 ,
: wrap-args@ ( -- c-addr u ) 
  wrap-args wrap-args-len @ ;

\ return types
0 constant n
2 constant a
3 constant r
4 constant func
5 constant void
6 constant s

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

: wrap-words-write ( c-addr u -- )
  wrap-words@ + wrap-words-len buff-write ;

: wrap-args-write ( c-addr u -- )
  wrap-args@ + wrap-args-len buff-write ;

: wrap-args-write-line ( c-addr u -- )
  wrap-args-write
  s\" \n" wrap-args-write ;

s" void addWords(void* fn) {"
addWords-write-line
s" af_t af = (af_t) fn;"
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

: reset-all ( -- )
  0 c-name-len !
  0 to lib-fileid
  0 wrap-args-len !
  0 forth-name-len !
  0 wrap-words-len !
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
  s" #define VOID  (0)"
  lib-write-line
  s" #define VALUE (1)"
  lib-write-line
  s" #define N(b) return (c_t)b"
  lib-write-line
  s" #define R(b) double d = b; return *(c_t*)&d"
  lib-write-line
  s" typedef void (*af_t)(void* fn, char* name, int argsNum, int returns);"
  lib-write-line
  s" typedef intptr_t c_t;"
  lib-write-line
;

: lib-end ( -- )
  s" } " addWords-write
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
  c-name@ lib-write s" _EX_WRP" lib-write ;

: write-addWords-wrap-name ( -- )
  c-name@ addWords-write s" _EX_WRP" addWords-write ;

: write-variable-func ( -- )
  s" static c_t " lib-write
  write-lib-wrap-name s" () { return (c_t)&" lib-write
  c-name@ lib-write s" ; }" lib-write-line
;

: write-bind-func ( f n -- ) \ returns? arg-num
  s" af(&" addWords-write write-addWords-wrap-name
  s\" , \"" addWords-write forth-name@ addWords-write
  s\" \", " addWords-write s>d <# #s #> addWords-write
  s" , " addWords-write
  if s" VALUE" else s" VOID" then
  addWords-write
  s" );" addWords-write-line
;

: transform-to-r ( c-addr1 u1 -- c-addr2 u2 )
  [char] { scan dup 0= if
    2drop
    s" r{*(double*)&}"
  else
    s" r{" pad swap move
    dup 1+ -rot \ save len
    pad 2+ swap move
    s" *(double*)&}"
    rot 2dup + \ get total len
    \ c-addr u u-pad u-final
    swap 2swap
    \ u-final u-pad c-addr u
    rot pad + swap move
    pad swap
  then
;


: transform-to-s ( c-addr1 u1 -- c-addr2 u2 )
  [char] { scan dup 0= if
    2drop
    s" r{(char*)}"
  else
    s" r{" pad swap move
    dup 1+ -rot \ save len
    pad 2+ swap move
    s" (char*)}"
    rot 2dup + \ get total len
    \ c-addr u u-pad u-final
    swap 2swap
    \ u-final u-pad c-addr u
    rot pad + swap move
    pad swap
  then
;
: write-arg-c ( c-addr u arg-num -- )
  dup 1 <> if s" , " wrap-args-write then

  -rot
  [char] { scan dup 0<> if
    2- swap 1+ swap wrap-args-write
  else 2drop then
  s>d <# #s [char] v hold #> wrap-args-write
;

: write-arg-forth ( n -- ) \ type
  dup s = if
    drop
    s" fth>c"
    wrap-words-write
  else
    r = if
      s" here f! here @" \ I don't want to destroy pad, arg strings might
      wrap-words-write
  then then
  s"  >r " wrap-words-write
;

: str>type ( c-addr u -- n )
  drop
  case
    dup s" n" text= ?of n endof
    dup s" a" text= ?of a endof
    dup s" r" text= ?of r endof
    dup s" func" text= ?of func endof
    dup s" void" text= ?of void endof
    dup s" s" text= ?of s endof
    37 throw
  endcase
;

: end-wrapper-word ( "type" -- n ) \ return-type
  forth-name@ wrap-words-write

  parse-name dup 0= -rot
  str>type dup -rot dup void =
  rot or not if
    dup s = if
      drop
      s"  c>fth" wrap-words-write
    else r = if
      s"  here ! here f@" wrap-words-write
    then then
  then

  s"  ;" wrap-words-write
;

: fill-arg-pop ( n -- )
  0 ?do
    s"  r> " wrap-words-write
  loop
;

: construct-wrapper-word ( "{type}" "--" "type" -- n n ) \ arg-num return-type
  \ begin writing wrapper word
  s"  : " wrap-words-write forth-name@ wrap-words-write
  s"  " wrap-words-write
  
  \ read until return type
  0 { args }
  begin
    parse-name
    2dup
    dup 0= -rot \ empty?
    drop
    s" --" text= or not
  while
    1 +to args

    2dup str>type
    dup void <> if
      dup dup r = if 
        drop -rot
        transform-to-r
      else
        s = if
          -rot
          transform-to-s
        else
          -rot
        then
      then
      args write-arg-c
      \ also accumulates types
    else 2drop then

  repeat
  2drop

  \ here I use the accumulated types
  args 0 ?do
    write-arg-forth
  loop

  args fill-arg-pop

  args
  end-wrapper-word
;

: get-return-macro ( n -- c-addr u )
  dup void = if drop s" ("
  else r = if s" R("
  else s" N("
  then then
;

: construct-wrapper-func ( n n -- ) \ arg-num return-type
  s" static " lib-write
  dup void = if s" void " else s" c_t " then lib-write
  write-lib-wrap-name
  s" (" lib-write
  swap 0 ?do
    i 0<> if s" , " lib-write then
    s" c_t v" lib-write
    i 1+ s>d <# #s #> lib-write
  loop
  s" ) {" lib-write-line

  get-return-macro lib-write

  c-name@ lib-write
  s" (" lib-write
  wrap-args@ lib-write
  s\" ));\n}" lib-write-line
;

: write-wraper-function ( "{type}" "--" "type" -- f n )
  0 wrap-args-len !
  construct-wrapper-word 2dup
  construct-wrapper-func
  void <> swap
;

}private

\ HERE WILL BE WORDSET...

\ \ \ \ \ \ \ \ \
\ USER CALLABLE \
\ \ \ \ \ \ \ \ \

: add-lib ( c-addr u -- )
  s"  -l" command-write command-write ;

: \c ( "..." -- )
  parse-line lib-write-line ;

: c-function ( "forth-name" "c-name" "{type}" "--" "type" -- )
  set-forth&c-names
  write-wraper-function
  write-bind-func
;

: c-variable ( "forth-name" "c-name" -- )
  set-forth&c-names
  write-variable-func
  true 0 write-bind-func
;

\ \ \ \ \ \ \ \ \
\ USER INTERFACE \
\ \ \ \ \ \ \ \ \ \

\ HERE WILL BE FORTH...

: c-library-name ( c-addr u -- )
  \ TODO: check if already compiled
  reset-all
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
  wrap-words@ 2dup type evaluate
;

privatize
