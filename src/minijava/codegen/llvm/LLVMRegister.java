package minijava.codegen.llvm;

import java.io.PrintWriter;
import minijava.codegen.llvm.type.Array;
import minijava.codegen.llvm.type.LLVMType;
import minijava.codegen.llvm.type.Pointer;

public class LLVMRegister {

  private final LLVMType type;
  private final String name;

  public LLVMRegister(LLVMType llvmType, String name) {
    this.type = llvmType;
    this.name = name;
  }

  public LLVMRegister getValue(LocalNameGenerator nameGenerator, PrintWriter writer) {
    if (type instanceof Pointer p && !(p.getUnderlying() instanceof Array)) {
      String newReg = nameGenerator.generateName();
      writer.println(
          "    " + newReg + " = load " + p.getUnderlying() + ", " + p.getUnderlying() + "* "
          + name);
      return new LLVMRegister(p.getUnderlying(), newReg);
    }
    return this;
  }

  @Override
  public String toString() {
    return type + " " + name;
  }

  public LLVMType getType() {
    return type;
  }

  public String getName() {
    return name;
  }
}
