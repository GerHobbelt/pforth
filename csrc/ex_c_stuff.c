#include "pf_all.h"
#include "ex_c_stuff.h"

#define CFUNC0_BYTES (sizeof(CFunc0) / 8)

extern CFunc0 CustomFunctionTable[];
extern size_t CustomFunctionLen;
size_t ExFTLen = -1;

CFunc0* ExtendedFunctionTable = CustomFunctionTable;

// currently allocates new string, copies FORTH string and adds \0
// maybe use the scratch buffer at some point?
char* toCstr(char* str, cell_t len) {
   char* newStr = malloc((len+1) * sizeof(char));
   memcpy(newStr, str, len);
   newStr[len] = '\0';
   return newStr;
}

// coppies CustomFunctionTable to a new dynamic ExtendedFunctionTable
void initExFT(void) {
   ExFTLen = CustomFunctionLen;

   ExtendedFunctionTable = malloc(ExFTLen * sizeof(CFunc0));
   memcpy(ExtendedFunctionTable, CustomFunctionTable, ExFTLen * CFUNC0_BYTES);
}

void addLib(char* name) {
   if (ExtendedFunctionTable == CustomFunctionTable) {
      initExFT();
   }

   // resize
   ExFTLen++;
   ExtendedFunctionTable = realloc(ExtendedFunctionTable, ExFTLen*CFUNC0_BYTES);

   ExtendedFunctionTable[ExFTLen-1] = (CFunc0) hello_world;
   CreateGlueToC(name, ExFTLen-1, C_RETURNS_VOID, 0);
}

#include <stdio.h>
void hello_world(void) {
   printf("\nHello, World!\n");
}
