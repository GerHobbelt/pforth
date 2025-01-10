: N>R ( i * n +n -- ) ( R: -- j * x +n )
  dup 0 > if

  \ for some reason all breaks when I use locals
  \ https://forth-standard.org/standard/tools/NtoR

  DUP                        \ xn .. x1 N N --
  BEGIN
    DUP
  WHILE
    ROT R> SWAP >R >R      \ xn .. N N -- ; R: .. x1 --
    1-                      \ xn .. N 'N -- ; R: .. x1 --
  REPEAT
  DROP                       \ N -- ; R: x1 .. xn --
  R> SWAP >R >R

  else
    drop
  then
;

: NR> ( -- i * x +n ) ( R: j * x +n -- )
  R> R> SWAP >R DUP
  BEGIN
    DUP
  WHILE
    R> R> SWAP >R -ROT
    1-
  REPEAT
  DROP
;
