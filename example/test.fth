include bindings.fth

s" libtestlib.so" include-clib

sourcefilename type cr

include test2.fth

require random.fs

hello-world
cr
hi!
cus!
zdrasti!

cr

30 7+ . cr

1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 LOOONG cr

OS-ID . cr

unix? . cr

cr cr

s" ls -a"
2dup type cr
system

." status: " $? . cr

.s

s\" ls -a /tmp" \ ls in uninteractive mode puts one entry per line
2dup type cr

sh-get
type cr

sh$ 2@ type cr

." status: " $? . cr

cr

parse-name kill.ME type cr

sh echo "$HOME"

lib-tst

." ---------" cr

utime ntime time&date .s
clearstack

s" HOME" getenv type cr

seed @ . cr

: print-random ( -- )
  25 0 do
    40 random 10 + .
    i 1+ 5 mod 0= if cr then
  loop
;

print-random

." ------VALUES------" cr
4 value int-val
4e fvalue float-val
int-val . float-val f. cr

5 +to int-val
3.4 +to float-val
int-val . float-val f. cr

\ wait, I can do this?
0 10 do
  i .
1 -loop

cr
." -------SF-------" cr

create sf-storage 8 allot

2.3 5.6 sf-storage 4 + sf! sf-storage sf!

sf-storage sf@ sf-storage 4 + sf@ f. f.

cr cr
." contents of 'test2.fth':" cr

-1 alter-path! \ custom variable used to toggle between paths relative to
                \ the user and to current file
s" test2.fth" slurp-file type

0 alter-path!

." -------------------------" cr

sourcefilename 2dup type cr
dirname type

sl" yay"
sl\" !!\tthey\twork\t!!
sl" ---------------- Strings Literals!! -------------------

cr cr type cr type cr type cr

cr

: TNR1 N>R SWAP NR> ;
1 2 10 20 30 3 TNR1
.s
clearstack

: TNR2 N>R N>R SWAP NR> NR> ;
1 2 10 20 30 3 40 50 2 TNR2
.s
clearstack

bye
