# extra words

This manual describes additional words that are not present in
[pforth](https://www.softsynth.com/pforth/).
I will not talk about words present in
[the FORTH standard](https://forth-standard.org/)
unless there is something notable about them.

Location of new words can be found
[here](changes.md).

## C interop

- INCLUDE-CLIB ( c-addr u -- )
    - Will load compiled binding file
    - You probably won't need to use this

- C-LIBRARY-NAME ( c-addr u -- )
    - Starts a new binding named based on string

- C-LIBRARY ( "name" -- )
    - Same as C-LIBRARY-NAME, but reads the next word instead

- END-C-LIBRARY ( -- )
    - Ends binding generating, compiles it and loads it

- C-FUNCTION ( "forth-name" "c-name" "{type}" "--" "type" -- )
    - Creates a binding for particular function

- C-VARIABLE ( "forth-name" "c-name" -- )
    - Creates a binding for particular variable

- \C ( "..." -- )
    - Adds a line of C into the bindings file
        - lines are added in order
        - can be used to create wrappers and such

- ADD-LIB ( c-addr u -- )
    - Adds a C library to be linked against the bindings

## OS

- OS-ID ( -- n )
    - Gives specific ID identifying the OS
    - You should not have the need to use it directly

- WINDOWS? ( -- f )
    - Is the host OS MS Windows?

- LINUX? ( -- f )
    - Is the host OS some sort of Linux?

- APPLE? ( -- f )
    - Is the host OS Darwin based?

- FREEBSD? ( -- f )
    - Is the host OS FreeBSD?

- NETBSD? ( -- f )
    - Is the host OS NetBSD?

- OPENBSD? ( -- f )
    - Is the host OS OpenBSD?

- UNIX? ( -- f )
    - LINUX? || FREEBSD? || NETBSD? || OPENBS? || anything that has
      __unix__ defined at compile
        - I don't trust apple to follow standards

## shell

- SYSTEM ( c-addr u -- )
    - Executes a shell command

- SH-GET ( c-addr1 u1 -- c-addr2 u2 )
    - Executes a shell command and returns the output

- SH ( "..." -- )
    - treats the rest of the line as a string and gives it to SYSTEM

- $? ( -- n )
    - Exit code of the last SYSTEM, SH-GET or SH

- GETENV ( c-addr1 u1 -- c-addr2 u2 )
    - Gets the value of a system environment variable

- sh$ ( -- c-addr )
    - returns address, that stores string and length of last SH-GET output

## files

- SOURCEFILENAME ( -- c-addr u )
    - Returns name of current file  
    - This string exists only while the file is interpreted.
      Store it somewhere (via STRING-SAVE?) if you need to use it after that

- DIRNAME ( c-addr1 u1 -- c-addr2 u2 )
    - Takes string containing path to a file and returns its parent directory

- ALTER-PATH! ( f -- )
    - Changes type of path resolution
        - 0 (default) : relative to user
        - -1 : relative to executed file

- ALTER-PATH@ ( -- f )
    - Fetches the type of path resolution
        - 0 (default) : relative to user
        - -1 : relative to executed file

- EMIT-FILE (c fileid -- ior)
    - Writes one char to a file

- SLURP-FILE ( c-addr1 u1 -- c-addr2 u2 ) 
    - Takes file name and returns its contents
    - Requires FREE

## float

- SF! ( r sf-addr -- )
    - Stores single-precision float

- SF@ ( sf-addr -- r )
    - Fetches single-precision float

- F, ( r -- )
    - ALLOTs and stores on float

- F+! ( r a-addr )
    - Adds r to float stored at a-addr

- FVALUE ( r "name" -- )
    - Line VALUE, but for floats

- F> ( r r -- f )
    - float greater than
    - really? This is not in the standard?

## UI

- CLEARSTACK ( -- )
    - Clears the data stack

- FCLEARSTACK ( -- )
    - Clears the floating-point stack

- CLEARSTACKS ( -- )
    - Clears both the data and floating-point stacks

## string

- STRING-SAVE ( c-addr1 u1 -- c-addr2 u2 )
    - ALLOTs and MOVEs string to new location

- SL" ( \<string\> -- c-addr u )
    - Like S" but ALLOTs new space instead of storing in PAD

- SL\\" ( \<string\> -- c-addr u )
    - Like S\\" but ALLOTs new space instead of storing in PAD

- PARSE-NAME ( "name" -- c-addr u )
    - Converts next word into a string

- PARSE-LINE ( "..." -- c-addr u )
    - Converts the entire rest of the line into a string

- FTH>C ( c-addr1 u1 -- c-addr2 )
    - Converts FORTH string to C string

- C>FTH ( c-addr -- c-addr u )
    - Converts C string to FORTH string

## structs

- 2FIELD: ( n1 "name" -- n2 ; addr1 -- addr2 )
    - 2 cells wide field

- WFIELD: ( n1 "name" -- n2 ; addr1 -- addr2 )
    - 16 bit wide field

- LFIELD: ( n1 "name" -- n2 ; addr1 -- addr2 )
    - 32 bit wide field

- XFIELD: ( n1 "name" -- n2 ; addr1 -- addr2 )
    - 64 bit wide field

## misc

- +TO ( val "name" -- )
    - Adds val to a value given by name

- -LOOP ( n -- )
    - Like +LOOP, but more negative

- UTIME ( -- n )
    - Time in microseconds since 1 January 1970

- NTIME ( -- n )
    - Time in nanoseconds since 1 January 1970
