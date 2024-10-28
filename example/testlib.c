#include <stdio.h>
// intptr_t
#include <stdint.h>

#define C_RETURNS_VOID  (0)
#define C_RETURNS_VALUE (1)

typedef void (*addFunction_t)(void* fn, char* name, int argsNum, int returns);
typedef intptr_t cell_t;

// define some eample functions
// they can only take and return the 'cell_t' type
// they don't need to be static

static void helloWorld(void) {
   printf("Hello, World~\n");
}

static cell_t addSeven(cell_t num) {
   return num + 7;
}

static void looong(cell_t p1, cell_t p2, cell_t p3, cell_t p4, cell_t p5,
                   cell_t p6, cell_t p7, cell_t p8, cell_t p9, cell_t p10,
                   cell_t p11, cell_t p12, cell_t p13, cell_t p14, cell_t p15)
{
   printf("%ld, %ld", p1, p15);
}

// DO NOT RENAME 'addWords'!
// it must be named like this
void addWords(void* fn) {
   // load the adder function
   addFunction_t addFunction = (addFunction_t) fn;

   // add the functions
   // name them in upcase
   addFunction(&helloWorld, "HELLO-WORLD", 0, C_RETURNS_VOID);
   addFunction(&addSeven, "7+", 1, C_RETURNS_VALUE);
   addFunction(&looong, "looong", 15, C_RETURNS_VOID);
}
