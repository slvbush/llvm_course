## Usage:
```
clang++ instruction_logging_pass.cpp -fPIC -shared -I$(llvm-config --includedir) -o libPass.so
clang -fpass-plugin=./libPass.so log.c ../hw1/sim.c ../hw1/app.c ../hw1/start.c -lSDL2 -lm -O2
```

