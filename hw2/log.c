#include <stdio.h>

// stats are collected in .cpp pass, I used this output to observe some things
// for debuggng
#ifdef DEBUG
#define DEBUG_LOG(...) fprintf(stdout, __VA_ARGS__)
#else
#define DEBUG_LOG(...) ((void)0)
#endif

void instrLogger(char *userName, char *operandName) {
  DEBUG_LOG("'%s' <- '%s'\n", userName, operandName);
}
