#ifndef SIM_H
#define SIM_H

#include <stdint.h>

#define SIM_X_SIZE 1536//512
#define SIM_Y_SIZE 768//256

#ifndef __sim__
void simInit();
void app();
void simExit();
void simFlush();
void simPutPixel(int x, int y, uint32_t argb);
int simRand();
float simSin(float);
float simCos(float);
void simFloatMemset(float* ptr, int32_t val, int32_t cnt);
void simIntMemset(uint32_t* ptr, int32_t val, int32_t cnt);
void simMemcpy(float* dst, const float* src, int32_t cnt);
float simFloatMod(float, float);
int simHasClick();
int simGetClick();
#endif // __sim__

#endif // SIM_H
