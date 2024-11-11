include bindings.fth

s" libtestlib.so" include-clib

sourcefilename type cr

include test2.fth

hello-world
cr
hi!
cus!
zdrasti!

cr

30 7+ . cr

1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 LOOONG cr

OS-ID . cr

unix? . cr

cr cr

s" ls -a"
2dup type cr
system

." status: " $? . cr

.s

s\" ls -a /tmp" \ ls in uninteractive mode puts one entry per line
2dup type cr

sh-get
type cr

sh$ 2@ type cr

." status: " $? . cr

cr

parse-name kill.ME type cr

sh echo "$HOME"

lib-tst

." ---------" cr

utime ntime time&date .s
drop drop drop drop drop drop drop drop drop drop

s" HOME" getenv type cr

require random.fs

random .

bye
