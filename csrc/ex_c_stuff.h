#ifndef ex_c_stuff
#define ex_c_stuff

#include "pf_all.h"

char* toCstr(char* ptr, cell_t len);
void initExFT(void);
void addLib(char* libName);
void addFunction(void* fn, char* name, int argsNum, int returns);

#endif
