#include "pf_all.h"
#include "ex_c_stuff.h"

// currently allocates new string, copies FORTH string and adds \0
// maybe use the scratch buffer at some point?
char* toCstr(char* str, cell_t len) {
   char* newStr = malloc((len+1) * sizeof(char));
   memcpy(newStr, str, len);
   newStr[len] = '\0';
   return newStr;
}
