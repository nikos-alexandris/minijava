package minijava.codegen.llvm.generators;

import java.io.PrintWriter;
import java.util.List;
import minijava.codegen.llvm.type.LLVMType;
import minijava.symboltable.mjclass.method.LocalVariable;

public class LocalVariablesGenerator {

  private final List<LocalVariable> localVariables;
  private final PrintWriter writer;

  public LocalVariablesGenerator(List<LocalVariable> localVariables, PrintWriter writer) {
    this.localVariables = localVariables;
    this.writer = writer;
  }

  public void generate() {
    for (LocalVariable localVariable : localVariables) {
      String name = localVariable.getName();
      LLVMType llvmType = LLVMType.fromMinijavaType(localVariable.getType());
      writer.println("    %" + name + " = alloca " + llvmType);
    }
  }
}
