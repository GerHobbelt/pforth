s" ./example/libtestlib.so" include-clib

include example/test2.fth

hi!

hello-world

30 7+ . cr

1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 looong cr

OS-ID . cr

unix? . cr

cr cr

s" ls -a"
2dup type cr
exec-shell

." status: " . cr
