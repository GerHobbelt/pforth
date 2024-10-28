# code changes made from default pforth

All changed/added files use 'ex_' prefix instead of the 'pf_' one.
Header files are renamed to match their files.
Changes in '#include's due to file name changes are not included.

## csrc/ex_guts.h
- added 'ID_OS_ID'
- added 'ID_INCLUDE_CLIB'
- added 'ID_SYSTEM_INNER'
- added 'SOURCEFILENAME'
- added 'DORNAME'

## csrc/excompil.c
- added 'INCLUDE-CLIB' word
- added 'OS-ID' word
- added 'SYSTEM-INNER' word
- added 'SOURCEFILENAME' word
- added 'DIRNAME' word
- made ffIncludeFile work with ex_include_dirs.c
- made it so that on error is thrown on BYE

## csrc/ex_inner.c
- added case for token 'ID_INCLUDE_CLIB'
- added case for token 'ID_OS_ID'
- added case for token 'ID_SYSTEM_INNER'
- added case for token 'SOURCEFILENAME'
- added case for token 'ID_DIRNAME'
- replaced FileStream with OpenedFile

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

## fth/loadex4th.fth
- added ex_os.fth
- added ex_shell.fth
- added ex_parse.fth

## fth/ex_os.fth
- all the OS words

## fth/ex_shell.fth
- all the shell execution words

## fth/ex_tetx.fth
- PARSE-NAME
- PARSE-LINE

## fth/mkdicdat.fth
- added bye, so it doesn't exit to REPL mid compiling
