c-library testlib
  \c static int var = 5;
  c-variable tst:var var
end-c-library

: lib-tst ( -- )
  tst:var c@ .
;
