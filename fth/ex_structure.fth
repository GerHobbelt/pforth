\ Structures and fields.
\
\ The code is based on the implementation from the ANS standard.
\
\ Permission to use, copy, modify, and/or distribute this
\ software for any purpose with or without fee is hereby granted.
\
\ THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
\ WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
\ WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
\ THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
\ CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
\ FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
\ CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
\ OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

anew task-ex_structure.fth

: BEGIN-STRUCTURE ( "<spaces>name" -- struct-sys 0 , start the definition of a structure )
    CREATE
        HERE 0 0 ,      \ mark stack, lay dummy
    DOES> @             \ -- structure-size
;

: END-STRUCTURE ( addr n -- , terminate a structure definition )
    SWAP !
;

: +FIELD  ( n <"name"> -- ; Exec: addr -- 'addr )
    CREATE OVER , +
    DOES> @ +
;

: FIELD:    ( n1 "name" -- n2 ; addr1 -- addr2 )
    ALIGNED 1 CELLS +FIELD
;

: CFIELD:   ( n1 "name" -- n2 ; addr1 -- addr2 )
    1 CHARS   +FIELD
;

: 2field: ( n1 "name" -- n2 ; addr1 -- addr2 )
  aligned 2 cells +field ;

: ffield: ( n1 "name" -- n2 ; addr1 -- addr2 )
  faligned 1 floats +field ;

: dffield: ( n1 "name" -- n2 ; addr1 -- addr2 )
  dfaligned 1 floats +field ;

: sffield: ( n1 "name" -- n2 ; addr1 -- addr2 )
  sfaligned 1 floats +field ;

: wfield: ( n1 "name" -- n2 ; addr1 -- addr2 )
  2 +field ;

: lfield: ( n1 "name" -- n2 ; addr1 -- addr2 )
  4 +field ;

: xfield: ( n1 "name" -- n2 ; addr1 -- addr2 )
  8 +field ;
