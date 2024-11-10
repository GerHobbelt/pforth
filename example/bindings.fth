c-library testlib
  s" m" add-lib

  \c #include <math.h>
  \c #include <stdio.h>

  \c typedef struct TestStruct {
  \c   int64_t n1;
  \c   int64_t n2;
  \c } TestStruct;

  \c void printStruct(TestStruct ts) { 
  \c   printf("I will give you my struct now:\n");
  \c   printf("  %d-%d\n", ts.n1, ts.n2);
  \c } 

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
  c-function c:print-structure printStruct a{*(TestStruct*)} -- void
end-c-library

create struct~ 6 , 9 ,

: lib-tst ( -- )
  10.0 m:sin f.
  tst:var c@ .
  cr 4.4 4 3 2 c:func .
  cr s" Hi from ex:forth~" handshake type cr
  struct~ c:print-structure 
;
