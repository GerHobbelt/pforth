\ Gforth compatible random number implementation
\ 0BSD

variable seed

: seed! ( n -- ) seed ! ;
: seed-init ( -- ) utime seed! ;
: rnd ( -- n ) 37 ;
: random ( n -- 0..n-1 ) rnd over mod ;
