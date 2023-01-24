package minijava.codegen.llvm.type;

public final class Pointer implements LLVMType {

  private final LLVMType underlying;

  public Pointer(LLVMType underlying) {
    this.underlying = underlying;
  }

  public LLVMType getUnderlying() {
    return underlying;
  }

  @Override
  public String toString() {
    return underlying + "*";
  }
}
