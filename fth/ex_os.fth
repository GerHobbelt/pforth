anew task-ex_os.fth

: windows? ( -- f )
  os-id 0 = ;

: linux? ( -- f )
  os-id 1 = ;

: apple? ( -- f )
  os-id 2 = ;

: freebsd? ( -- f )
  os-id 3 = ;

: netbsd? ( -- f )
  os-id 4 = ;

: openbsd? ( -- f )
  os-id 5 = ;

: unix? ( -- f )
  os-id 10 =
  linux? or
  freebsd? or
  netbsd? or
  openbsd? or
;
