c-library testlib
  s" m" add-lib

  \c #include <math.h>

  \c static int var = 5;

  c-function m:sin sin r -- r
  c-variable tst:var var
end-c-library

: lib-tst ( -- )
  tst:var c@ .
  10.0 m:sin f.
;
