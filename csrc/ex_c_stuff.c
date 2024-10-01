#include <dlfcn.h>

#include "pf_all.h"
#include "ex_c_stuff.h"

#define CFUNC0_BYTES (sizeof(CFunc0) / 8)
typedef void (*addWords_t)(void* num);

extern CFunc0 CustomFunctionTable[];
extern size_t CustomFunctionLen;
size_t ExFTLen = -1;

// I need resizable pointer
CFunc0* ExtendedFunctionTable = CustomFunctionTable;

// currently allocates new string, copies FORTH string and adds \0
// maybe use the scratch buffer at some point?
char* toCstr(char* str, cell_t len) {
   // TODO: check for alloc fail
   char* newStr = malloc((len+1) * sizeof(char));
   memcpy(newStr, str, len);
   newStr[len] = '\0';
   return newStr;
}

// coppies CustomFunctionTable to a new dynamic ExtendedFunctionTable
void initExFT(void) {
   ExFTLen = CustomFunctionLen;

   // TODO: check for alloc fail
   ExtendedFunctionTable = malloc(ExFTLen * sizeof(CFunc0));
   memcpy(ExtendedFunctionTable, CustomFunctionTable, ExFTLen * CFUNC0_BYTES);
}

// adds a function from a ptr
void addFunction(void* fn, char* name, int argsNum, int returns) {
   // TODO: check for wrong num fail
   // resize
   ExFTLen++;
   // TODO: check for alloc fail
   ExtendedFunctionTable = realloc(ExtendedFunctionTable, ExFTLen*CFUNC0_BYTES);

   // add
   ExtendedFunctionTable[ExFTLen-1] = (CFunc0) fn;
   CreateGlueToC(name, ExFTLen-1, returns, argsNum);
}

// what gets called from INCLUDE-CLIB
#include <stdio.h>
void addLib(char* libName) {
   // init if needed
   if (ExtendedFunctionTable == CustomFunctionTable) {
      initExFT();
   }

   // TODO: make is somehow depend on current file interpreted
   // TODO: add some error handling
   // TODO: add Windows support
   void* handle = dlopen(libName, RTLD_LAZY);
   addWords_t addWords = (addWords_t) dlsym(handle, "addWords");
   addWords((void*) &addFunction);
}
