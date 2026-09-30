Kuramoto model visualisation

Mac build:
```
clang start.c sim.c myapp.c \
  -I"$(sdl2-config --prefix)/include" \
  $(sdl2-config --cflags --libs) \
  -lm -o myapp
```

Linux build is analogous.
