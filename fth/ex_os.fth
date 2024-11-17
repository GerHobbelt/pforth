anew task-ex_os.fth

: WINDOWS? ( -- f )
  os-id 0 = ;

: LINUX? ( -- f )
  os-id 1 = ;

: APPLE? ( -- f )
  os-id 2 = ;

: FREEBSD? ( -- f )
  os-id 3 = ;

: NETBSD? ( -- f )
  os-id 4 = ;

: OPENBSD? ( -- f )
  os-id 5 = ;

: UNIX? ( -- f )
  os-id 10 =
  linux? or
  freebsd? or
  netbsd? or
  openbsd? or
;
