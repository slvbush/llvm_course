#ifndef SIM_H
#define SIM_H

#define SIM_X_SIZE 1536//512
#define SIM_Y_SIZE 768//256

#ifndef __sim__
void simInit();
void app();
void simExit();
void simFlush();
void simPutPixel(int x, int y, unsigned argb);
int simRand();
float simSin(float);
float simCos(float);
void simFloatMemset(float* ptr, int val, int cnt);
void simIntMemset(unsigned* ptr, int val, int cnt);
void simMemcpy(float* dst, const float* src, int cnt);
float simFloatMod(float, float);
int simHasClick();
int simGetClick();
#endif // __sim__

#endif // SIM_H
