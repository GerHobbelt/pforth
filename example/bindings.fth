c-library testlib
  s" m" add-lib

  \c #include <math.h>
  \c #include <stdio.h>

  \c int customFunc(int x, int y, float z, int p) {
  \c   printf("> %d %d %f %d\n", x, y, z, p);
  \c   return (x+y - (int)z + p);
  \c }

  \c char* handshake(char* in) {
  \c   printf("%s\n", in);
  \c   return "Hi from C!";
  \c } 

  \c static int var = 5;

  c-function m:sin sin r -- r
  c-variable tst:var var
  c-function c:func customFunc n n r n -- n
  c-function handshake handshake s -- s
end-c-library

: lib-tst ( -- )
  tst:var c@ .
  10.0 m:sin f.
  cr 4.4 4 3 2 c:func .
  cr s" Hi from ex:forth~" handshake type cr
;
