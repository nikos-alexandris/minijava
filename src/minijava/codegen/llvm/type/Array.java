package minijava.codegen.llvm.type;

public final class Array implements LLVMType {

  private final Primitive underlying;

  public Array(Primitive underlying) {
    this.underlying = underlying;
  }

  public Primitive getUnderlying() {
    return underlying;
  }

  @Override
  public String toString() {
    return "%\"" + underlying + "[]\"";
  }
}
