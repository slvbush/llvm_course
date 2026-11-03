all: app

start.ll: start.c
	clang -emit-llvm -S $^
sim.ll: sim.c
	clang -emit-llvm -S $^
app.ll: app.c
	clang -emit-llvm -S $^
full.bc: start.ll sim.ll app.ll
	llvm-link $^ -o full.bc

app-opt.ll: app.c
	clang -emit-llvm -S $^ -o $@ -O2

app: app.ll start.c sim.c
	clang $^ -lSDL2 -lm -o $@
app-opt: app-opt.ll start.c sim.c
	clang $^ -lSDL2 -o $@ -O2

LLVM_FLAGS = $(shell llvm-config --cppflags --ldflags --libs)

clean:
	rm app app-opt *.ll full.bc ir_gen asm2ir asm2fullir

.PHONY: all clean
