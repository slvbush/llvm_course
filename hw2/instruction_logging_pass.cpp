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
  Type *voidType;
  Type *int8PtrTy;
  DenseMap<unsigned, Value *> instructionsToGlobalNames =
      DenseMap<unsigned, Value *>();

  bool insertInstructionsLog(Module &M, Function &F, IRBuilder<> &builder) {
    ArrayRef<Type *> callParamTypes = {int8PtrTy, int8PtrTy};
    FunctionType *instrLogFuncType =
        FunctionType::get(voidType, callParamTypes, false);

    FunctionCallee callLogFunc =
        M.getOrInsertFunction("instrLogger", instrLogFuncType);

    bool Inserted = false;
    for (auto &B : F) {
      for (auto &I : B) {
        if (I.getOpcode() == Instruction::PHI) {
          continue;
        }

        builder.SetInsertPoint(&I);

        if (instructionsToGlobalNames.find(I.getOpcode()) ==
            instructionsToGlobalNames.end()) {
          instructionsToGlobalNames[I.getOpcode()] =
              builder.CreateGlobalStringPtr(I.getOpcodeName());
        }

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

    if (M.getName() == "../hw1/app.c") {
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

    return PreservedAnalyses::none();
  };
};

PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    PB.registerOptimizerLastEPCallback([](ModulePassManager &MPM, auto) {
      MPM.addPass(MyModPass{});
      return true;
    });
  };

  return {LLVM_PLUGIN_API_VERSION, "MyPlugin", "0.0.1", callback};
};

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}
