#ifndef ex_c_stuff
#define ex_c_stuff

#include "pf_all.h"

char* interpretStringToC(char* dst, const char* src, cell_t dstSize);
void initExFT(void);
void addLib(char* libName);
void addFunction(void* fn, char* name, int argsNum, int returns);

#endif
