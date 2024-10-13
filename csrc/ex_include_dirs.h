#ifndef ex_include_dirs
#define ex_include_dirs

void addDir(OpenedFile* descriptor);
void dropDir(void);
char* getPath(const char* origDir, char* buff);
char* getCurrentPath(void);

void setCurrentFilename(const char* name);
char* getCurrentFilename(void);

#endif
