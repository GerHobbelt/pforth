anew task-ex_facility.fth

\ TODO: windows support for AT-XY
: AT-XY ( x y -- )
  WINDOWS? IF
    drop drop
    ." AT-XY currently not supported on Windows"
  ELSE
    s\" \e[" type
    0 <# #S #> type
    ." ;"
    0 <# #S #> type
    ." H"
  THEN
;
