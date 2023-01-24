package minijava.codegen.llvm.type;

public final class Class implements LLVMType {

  private final String className;

  public Class(String className) {
    this.className = className;
  }

  public String getClassName() {
    return className;
  }

  @Override
  public String toString() {
    return "i8*";
  }
}
