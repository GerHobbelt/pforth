# code changes made from default pforth

All changed/added files use 'ex_' prefix instead of the 'pf_' one.
Header files are renamed to match their files.
Changes in '#include's due to file name changes are not included.

## csrc/ex_guts.h
- replace one reserved ID with 'ID_INCLUDE_CLIB'

## csrc/excompil.c
- added 'INCLUDE-CLIB' word

## csrc/ex_inner.c
- added case for token 'INCLUDE-CLIB'

## csrc/excustom.c
- made CustonFunctionLen mandatory

## csrc/ex_cglue.c
- adde CFunc6 - CFunc15

## csrc/ex_cglue.c
- use ExtendedFunctionTable instead of CustomFunctionTable
- applied the extended CFuncs

## csrc/ex_c_stuff.c
- here I store my stuff
- convertor to C-strings
- lib inclusion
