#include "sim.h"

// Kuramoto neighboring model (not all oscillators affect each other, but only 4 neighbors of the oscilator-dot)
#define PI 3.1415927f
#define TIME_STEP 0.1f // less for better precision
#define POINTS_ONE_DIM 700 // yet the biggest i could make
#define GRID_SIZE (POINTS_ONE_DIM * POINTS_ONE_DIM) // yet the biggest i could make
#define COUPLING 10 // for bigger structures and cooler look
#define ADDITIONAL_MODULO PI // change for different color distribution, i like PI
#define COLOR_SHIFT PI / 12.0f // use to shift the colors, i like PI / 12.0f

void drawGrid(unsigned* grid) {
  for (int i = 0; i != POINTS_ONE_DIM; ++i) {
    for (int j = 0; j != POINTS_ONE_DIM; ++j) {
      simPutPixel(i + SIM_X_SIZE / 2 - POINTS_ONE_DIM / 2, j + SIM_Y_SIZE / 2 - POINTS_ONE_DIM / 2, grid[i * POINTS_ONE_DIM + j]);
    }
  }
}

float calcSum(float tetta, const float* angles, int i, int j) {
  float res = 0.0;
  int amount = 0;

  int left = (j == 0); 
  int right = (j == POINTS_ONE_DIM - 1);
  int up = (i == 0);
  int down = (i == POINTS_ONE_DIM - 1);

  if (!left) {
    ++amount;
    res += simSin(angles[j - 1 + i * POINTS_ONE_DIM] - tetta);
  }
  if (!right) {
    ++amount;
    res += simSin(angles[j + 1 + i * POINTS_ONE_DIM] - tetta);
  }
  if (!up) {
    ++amount;
    res += simSin(angles[j + (i - 1) * POINTS_ONE_DIM] - tetta);
  }
  if (!down) {
    ++amount;
    res += simSin(angles[j + (i + 1) * POINTS_ONE_DIM] - tetta);
  }

  return res * ((float)COUPLING / (float)amount);
}

unsigned calcColour(float tetta) {
  unsigned a = 255u;
  float r = (simCos(tetta) + 1.0f) / 2.0f;
  float g = (simCos(tetta - 2.0f * PI / 3.0f) + 1.0f) / 2.0f;
  float b = (simCos(tetta - 4.0f * PI / 3.0f) + 1.0f) / 2.0f;

  return (a << 24) | ((unsigned)(255.0f * r) << 16) | ((unsigned)(255.0f * g) << 8) | ((unsigned)(255.0f * b));
}

void recount(unsigned* grid, float* phases, float* old_phases, float* freqs) {
  simMemcpy(old_phases, phases, sizeof(float) * POINTS_ONE_DIM * POINTS_ONE_DIM);

  for (int i = 0; i != POINTS_ONE_DIM; ++i) {
    for (int j = 0; j != POINTS_ONE_DIM; ++j) {
      float old_tetta = old_phases[i * POINTS_ONE_DIM + j];
      float new_tetta = simFloatMod((old_tetta 
        + TIME_STEP * (
          freqs[i * POINTS_ONE_DIM + j] + calcSum(old_tetta, old_phases, i, j))
        ), 2 * PI);

      if (new_tetta < 0) {
        new_tetta += 2 * PI;
      }
      phases[i * POINTS_ONE_DIM + j] = new_tetta;

      unsigned color = calcColour(simFloatMod(new_tetta, ADDITIONAL_MODULO) + COLOR_SHIFT);
      grid[i * POINTS_ONE_DIM + j] = color;
    }
  }
}

void app(void) {
  int MAX_FREQ = 100;
  
  unsigned grid[GRID_SIZE];
  float phases[GRID_SIZE];
  float old_phases[GRID_SIZE];
  float freqs[GRID_SIZE];
  simIntMemset(grid, 0, sizeof(grid[0]) * GRID_SIZE);
  simFloatMemset(phases, 0, sizeof(phases[0]) * GRID_SIZE);
  simFloatMemset(freqs, 0, sizeof(freqs[0]) * GRID_SIZE);

  for (int i = 0; i != POINTS_ONE_DIM; ++i) {
    for (int j = 0; j != POINTS_ONE_DIM; ++j) {
      phases[j + i * POINTS_ONE_DIM] = simFloatMod((float)simRand(), 2 * PI);
      freqs[j + i * POINTS_ONE_DIM] = (float)(simRand() % MAX_FREQ) / 100.0f; // "uniform" distr. from 0 to 1
    }
  }

  while (1) {
    recount(grid, phases, old_phases, freqs);
    drawGrid(grid);
    simFlush();
  }
}
