# code changes made from default pforth

All changed/added files use 'ex_' prefix instead of the 'pf_' one.
Header files are renamed to match their files.
Changes in '#include's due to file name changes are not included.

## csrc/ex_guts.h
- added 'ID_OS_ID'
- added 'ID_INCLUDE_CLIB'
- added 'ID_SYSTEM_INNER'
- added 'ID_SH_GET_INNER'
- added 'ID_SOURCEFILENAME'
- added 'ID_DIRNAME'
- added 'ID_TIME_N_DATE'
- added 'ID_UTIME'
- added 'ID_NTIME'
- added 'ID_FLOAT'
- added 'ID_MINUSLOOP_P'
- added 'ID_FP_SF_STORE'
- added 'ID_FP_SF_FETCH'
- added the 'SFLOAT' macros

## csrc/excompil.c
- added 'INCLUDE-CLIB' word
- added 'OS-ID' word
- added '(SYSTEM)' word
- added '(SH-GET)' word
- added 'SOURCEFILENAME' word
- added 'DIRNAME' word
- added 'TIME&DATE' word
- added 'UTIME' word
- added 'NTIME' word
- added 'FLOAT' word
- added '(-LOOP)' word
- made ffIncludeFile work with ex_include_dirs.c
- made it so that on error is thrown on BYE
- added 'SF!' word
- added 'SF@' word

## csrc/ex_inner.c
- added case for token 'ID_INCLUDE_CLIB'
- added case for token 'ID_OS_ID'
- added case for token 'ID_SYSTEM_INNER'
- added case for token 'ID_SH_GET_INNER'
- added case for token 'SOURCEFILENAME'
- added case for token 'ID_DIRNAME'
- added case for token 'ID_TIME_N_DATE'
- added case for token 'ID_UTIME'
- added case for token 'ID_NTIME'
- added case for token 'ID_FLOAT'
- added case for token 'ID_MINUSLOOP_P'
- replaced FileStream with OpenedFile

## csrc/exinnrfp.h
- added case for token 'ID_FP_SF_STORE'
- added case for token 'ID_FP_SF_FETCH'

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
- added functions for reading and writing single floats in both endians
- that also includes for reversing

## fth/loadex4th.fth
- added ex_os.fth
- added ex_shell.fth
- added ex_parse.fth
- added ex_clib.fth
- added ex_strings.fth

## fth/ex_misc2.fth
- moved MOVE to ex_system.fth

## fth/ex_system.fth
- moved MOVE here
- made include search in specific prefixes
- -LOOP

## fth/ex_smart_if.fth
- -LOOP wrap

## fth/ex_os.fth
- all the OS words

## fth/ex_shell.fth
- all the shell execution words
- .local include prefix

## fth/ex_tetx.fth
- PARSE-NAME
- PARSE-LINE

## fth/ex_clib.fth
- all the C-LIBRARY stuff

## fth/ex_ansilocs
- added +TO
- added F,
- added F+!
- added FVALUE

## fth/ex_local_share/random.fs
- pseudorandom number generator

## fth/ex_strings
- additional string words
- C>FTH, FTH>C

## fth/ex_structure
- more FIELD: words

## fth/ex_floats
- DFALIGN, SFALIGN, DFALIGNED, SFALIGNED
- DFFIELD, SFFIELD

## fth/mkdicdat.fth
- added bye, so it doesn't exit to REPL mid compiling

## fth/ex_file.fth
- added EMIT-FILE
- added SLURP-FILE (requires FREE)
