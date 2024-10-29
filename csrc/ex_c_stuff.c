#include <dlfcn.h>

#include "pf_all.h"
#include "ex_c_stuff.h"

#define CFUNC0_BYTES (sizeof(CFunc0) / 8)
typedef void (*addWords_t)(void* num);

extern CFunc0 CustomFunctionTable[];
extern size_t CustomFunctionLen;
size_t ExFTLen = -1;

char libnameBuff[128];

// I need resizable pointer
CFunc0* ExtendedFunctionTable = CustomFunctionTable;

char* interpretStringToC(char* dst, const char* src, cell_t dstSize) {

    cell_t len;

    len = (cell_t) *src +1;
    /* Make sure the text + NUL can fit. */
    if( len >= dstSize )
    {
        len = dstSize;
    }

   pfCopyMemory(dst, src, len);
   dst[len] = '\0';

   return dst;
}

// coppies CustomFunctionTable to a new dynamic ExtendedFunctionTable
void initExFT(void) {
   ExFTLen = CustomFunctionLen;

   ExtendedFunctionTable = malloc(ExFTLen * sizeof(CFunc0));
   if (ExtendedFunctionTable == NULL) {
      pfReportError("INCLUDE-CLIB", PF_ERR_NO_MEM);
      EXIT(1);
   }
   memcpy(ExtendedFunctionTable, CustomFunctionTable, ExFTLen * CFUNC0_BYTES);
}

// adds a function from a ptr
void addFunction(void* fn, char* name, int argsNum, int returns) {
   // check
   if (argsNum < 0 || argsNum > MAX_CFUNC_ARGS) {
      MSG("Too many args for ");
      MSG(name);
      EMIT_CR;
      MSG_NUM_D("Maximum allowed args is ", MAX_CFUNC_ARGS);
      EMIT_CR;
      EXIT(1);
   }

   // resize
   ExFTLen++;

   ExtendedFunctionTable = realloc(ExtendedFunctionTable, ExFTLen*CFUNC0_BYTES);
   if (ExtendedFunctionTable == NULL) {
      pfReportError("INCLUDE-CLIB", PF_ERR_NO_MEM);
      EXIT(1);
   }

   // add
   ExtendedFunctionTable[ExFTLen-1] = (CFunc0) fn;
   CreateGlueToC(name, ExFTLen-1, returns, argsNum);
}

// what gets called from INCLUDE-CLIB
void addLib(char* libName) {
   // init if needed
   if (ExtendedFunctionTable == CustomFunctionTable) {
      initExFT();
   }

   // TODO: make is somehow depend on current file interpreted
   // TODO: add Windows support
   void* handle = dlopen(getPath(libName, libnameBuff), RTLD_LAZY);
   if (handle == NULL) {
      printf("Error in INCLUDE-CLIB - could not open file %s",
             getPath(libName, libnameBuff));
      EXIT(1);
   }
   addWords_t addWords = (addWords_t) dlsym(handle, "addWords");
   if (addWords == NULL) {
      MSG(libName);
      MSG(" does not have function: void addWords(void* fn)");
      EMIT_CR;
      EXIT(1);
   }

   addWords((void*) &addFunction);
}
