## Usage:
```
clang++ instruction_logging_pass.cpp -fPIC -shared -I$(llvm-config --includedir) -o libPass.so
clang++ -O2 -fpass-plugin=./libPass.so -x c++ log.cpp -x c ../hw1/sim.c ../hw1/app.c ../hw1/start.c -lSDL2 -lm -o app
./app
```

