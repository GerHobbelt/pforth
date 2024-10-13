# code changes made from default pforth

All changed/added files use 'ex_' prefix instead of the 'pf_' one.
Header files are renamed to match their files.
Changes in '#include's due to file name changes are not included.

## csrc/ex_guts.h
- replace one reserved ID with 'ID_INCLUDE_CLIB'
- replace one reserved ID with 'ID_OS_ID'
- replace one reserved ID with 'ID_EXEC_SHELL'
- replace one reserved ID with 'SOURCEFILENAME'

## csrc/excompil.c
- added 'INCLUDE-CLIB' word
- added 'OS-ID' word
- added 'EXEC-SHELL' word
- added 'SOURCEFILENAME' word
- made ffIncludeFile work with ex_include_dirs.c

## csrc/ex_inner.c
- added case for token 'ID_INCLUDE_CLIB'
- added case for token 'ID_OS_ID'
- added case for token 'ID_EXEC_SHELL'
- replaced FileStream with OpenedFile
- added case for token 'SOURCEFILENAME'

## csrc/excustom.c
- made CustonFunctionLen mandatory

## csrc/ex_cglue.c
- adde CFunc6 - CFunc15

## csrc/ex_cglue.c
- use ExtendedFunctionTable instead of CustomFunctionTable
- applied the extended CFuncs

## csrc/ex_c_stuff.c
- my own to Cstr
- lib inclusion

## csrc/ex_io.c
- modified sdFileOpen and sdFileClose to work with OpenedFile struct instead of FILE*

## csrc/ex_include_dirs.c
- includes relative to file

## csrc/ex_core.c
- changed FileStream to OpenedFile

## csrc/ex_save.c
- modified to work with OpenedFile

## fth/ex_os.fth
- all the OS words

## fth/loadex4th.fth
- added ex_os.fth
