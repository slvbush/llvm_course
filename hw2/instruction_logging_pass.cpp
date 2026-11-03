#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include <llvm/IR/Instruction.h>
#include <llvm/IR/PassManager.h>

using namespace llvm;

struct MyModPass : public PassInfoMixin<MyModPass> {
  // what are those types?
  Type *voidType;
  Type *int8PtrTy;

  bool insertInstructionsLog(Module &M, Function &F, IRBuilder<> &builder) {
    // Prepare instrLogger function: User, Operand
    ArrayRef<Type *> callParamTypes = {int8PtrTy, int8PtrTy};
    FunctionType *instrLogFuncType =
        FunctionType::get(voidType, callParamTypes, false);

    /*
    what does this method do?

    check with "gd".. tldr: adds a prototype for the function and returns it
    (in our case because there is no decl for logger around)
    */
    FunctionCallee callLogFunc =
        M.getOrInsertFunction("instrLogger", instrLogFuncType);

    bool Inserted = false;
    for (auto &B : F) {
      for (auto &I : B) {
        // what are another interfaces available for instructions checking?
        // i have no clue..
        if (I.getOpcode() == Instruction::PHI) {
          continue;
        }

        // Insert before operand call -- wrong
        // why SetInsertPoint is needed?
        builder.SetInsertPoint(&I);

        // why creating a global string is needed?
        Value *instName = builder.CreateGlobalStringPtr(I.getOpcodeName());
        for (auto *U : I.users()) {
          if (auto *UserInst = dyn_cast<Instruction>(U)) {
            if (UserInst->getOpcode() == Instruction::PHI) {
              continue;
            }

            Value *userName =
                builder.CreateGlobalStringPtr(UserInst->getOpcodeName());
            Value *args[] = {userName, instName};
            // what is create call and how does it work?
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
    // how to check better? maybe somehow get a path for a valid module? or
    // validate with function names? (namespaces required)
    if (M.getName() == "../hw1/app.c") {
      // what are those 4 lines of code?
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
    return changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
  };
};

PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    // does it mean we will execute our pass after the optimizations happen?
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
