#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include <llvm-18/llvm/ADT/DenseMap.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/PassManager.h>

using namespace llvm;

struct MyModPass : public PassInfoMixin<MyModPass> {
  // what are those types?
  // special compiler type aliases
  Type *voidType;
  Type *int8PtrTy;
  DenseMap<unsigned, Value *> instructionsToGlobalNames =
      DenseMap<unsigned, Value *>();

  bool insertInstructionsLog(Module &M, Function &F, IRBuilder<> &builder) {
    // Prepare instrLogger function: User, Operand
    ArrayRef<Type *> callParamTypes = {int8PtrTy, int8PtrTy};
    FunctionType *instrLogFuncType =
        FunctionType::get(voidType, callParamTypes, false);

    /*
    what does this function do?

    check with "gd".. tldr: adds a prototype for the function and returns it
    (in our case because there is no decl for logger around)
    */
    FunctionCallee callLogFunc =
        M.getOrInsertFunction("instrLogger", instrLogFuncType);

    bool Inserted = false;
    for (auto &B : F) {
      for (auto &I : B) {
        // if the user is PHI - we skip
        if (I.getOpcode() == Instruction::PHI) {
          continue;
        }

        // maybe we should not do it like that, because at this point
        // there is no guarantee we are actually going to insert our logging
        // call
        builder.SetInsertPoint(&I);

        if (instructionsToGlobalNames.find(I.getOpcode()) ==
            instructionsToGlobalNames.end()) {
          instructionsToGlobalNames[I.getOpcode()] =
              builder.CreateGlobalStringPtr(I.getOpcodeName());
        }

        // Value *instName = builder.CreateGlobalStringPtr(I.getOpcodeName());
        Value *instName = instructionsToGlobalNames[I.getOpcode()];

        for (const auto &operand : I.operands()) {
          if (auto operandInstruction = dyn_cast<Instruction>(operand)) {
            if (instructionsToGlobalNames.find(
                    operandInstruction->getOpcode()) ==
                instructionsToGlobalNames.end()) {
              instructionsToGlobalNames[operandInstruction->getOpcode()] =
                  builder.CreateGlobalStringPtr(
                      operandInstruction->getOpcodeName());
            }

            Value *operandInstName =
                instructionsToGlobalNames[operandInstruction->getOpcode()];
            Value *args[] = {instName, operandInstName};
            // create an actual call on the current insert point
            builder.CreateCall(callLogFunc, args);
            Inserted = true;
          }
        }
      }
    }
    return Inserted;
  }

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    bool changed = false;

    // bad check but whatever
    if (M.getName() == "../hw1/app.c") {
      // create necessary attributes
      LLVMContext &Ctx = M.getContext();
      IRBuilder<> builder(Ctx);
      voidType = Type::getVoidTy(Ctx);
      int8PtrTy = Type::getInt8Ty(Ctx)->getPointerTo();

      for (auto &F : M) {
        if (F.isDeclaration()) {
          continue;
        }

        if (insertInstructionsLog(M, F, builder)) {
          changed = true;
        }
      }
    }

    // what other options are there?
    // go check with "gd" - there are a lot
    return PreservedAnalyses::none();
  };
};

PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    // does it mean we will execute our pass after the optimizations happen?
    // yes, contract can be checked with "gd"
    PB.registerOptimizerLastEPCallback([](ModulePassManager &MPM, auto) {
      MPM.addPass(MyModPass{});
      return true;
    });
  };

  return {LLVM_PLUGIN_API_VERSION, "MyPlugin", "0.0.1", callback};
};

/* When a plugin is loaded by the driver, it will call this entry point to
obtain information about this plugin and about how to register its passes.
*/
extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}
