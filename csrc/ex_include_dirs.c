#include <string.h>
#include "pf_all.h"

char* paths[32];
int CurrentPathsLen = 0;
char pathBuff_1[256];
char pathBuff_2[256];

char currentFilename[255] = ".";

static int isAbsolute(const char* path) {
#if defined(__WIN32) || defined(_WIN64)
  // TODO: add windows absolute path support
#else
  return (path[0] == '/');
#endif
}

// WILL NOT CHECK IF IS DIR
// USE ONLY ON FILES!
static char* baseDir(const char* path, char* buff) {
  memcpy(buff, path, strlen(path)+1);

  // replace last '/' with '\0'
  for(int i = strlen(buff); i > 0; i--) {
    if (buff[i] == '/') {
      buff[i] = '\0';
      return buff;
    }
  }

  // if absolute
  if (buff[0] == '/') {
    buff[1] = '\0';
    return buff;
  }

  // else just return nothing
  buff[0] = '\0';
  return buff;
}

static char* pathJoin(const char* p1, const char* p2, char* buff) {
  int p1Len = strlen(p1);

  if (isAbsolute(p2) || p1[0] == '\0') {
    memcpy(buff, p2, strlen(p2)+1);

  } else {
    memcpy(buff, p1, p1Len);

    // if some p2
    if (p2[0] != '\0' && (p2[0] != '.' || p2[1] != '\0')) {
      buff[p1Len] = '/';
      memcpy(buff +1+ p1Len, p2, strlen(p2)+1);

    } else {
      buff[p1Len] = '\0';
    }
  }

  return buff;
}

char* getCurrentPath(void) {
  if (CurrentPathsLen > 0) {
    return paths[CurrentPathsLen-1];
  } else {
    static char dot[] = ".";
    return dot;
  }
}

char* getPath(const char* origDir, char* buff) {
  return pathJoin(getCurrentPath(), origDir, buff);
}

void addDir(OpenedFile* descriptor) {
  char* dir = baseDir(descriptor->name, pathBuff_1);
  char* new;
  int dirSize = strlen(dir);

  if (CurrentPathsLen == 32) return;

  if (isAbsolute(dir) || CurrentPathsLen == 0) {
    // just duplicate and save
    new = malloc((dirSize+1)*sizeof(char));
    memcpy(new, dir, dirSize+1);

  } else {
    // join
    pathJoin(getCurrentPath(), dir, pathBuff_2);

    // duplicate
    int len = strlen(pathBuff_2);
    new = malloc((len+1)*sizeof(char));
    memcpy(new, pathBuff_2, len+1);
  }

  // save
  paths[CurrentPathsLen] = new;
  CurrentPathsLen++;
}

void dropDir(void) {
  if (CurrentPathsLen == 0) return;

  free(getCurrentPath());
  CurrentPathsLen--;
}

void setCurrentFilename(const char* name) {
  memcpy(currentFilename, name, sizeof(currentFilename) / sizeof(char));
}

char* getCurrentFilename(void) {
  return currentFilename;
}
