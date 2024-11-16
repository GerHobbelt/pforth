\ Gforth compatible random number implementation
\ 0BSD

variable seed

: seed! ( n -- ) seed ! ;
: seed-init ( -- ) ntime drop seed ! ;

\ https://en.wikipedia.org/wiki/Linear_congruential_generator
: rnd ( -- n )
  \ Musl values
  #6364136223846793005 seed @ * 1+ \ natural overflow as modulus
  dup seed ! ;
: random ( n -- 0..n-1 ) rnd swap mod abs ;

seed-init
