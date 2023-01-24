package minijava.codegen.llvm.type;

public final class Boolean implements Primitive {

  @Override
  public String toString() {
    return "i1";
  }

  @Override
  public int sizeInBytes() {
    return 1;
  }
}
