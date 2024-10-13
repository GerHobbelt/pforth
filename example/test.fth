s" ./example/libtestlib.so" include-clib

sourcefilename type cr

include test2.fth

hello-world
cr
hi!
cus!
zdrasti!

cr

30 7+ . cr

1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 looong cr

OS-ID . cr

unix? . cr

cr cr

s" ls -a"
2dup type cr
exec-shell

." status: " . cr
