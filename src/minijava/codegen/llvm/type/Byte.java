package minijava.codegen.llvm.type;

public final class Byte implements Primitive {

  @Override
  public String toString() {
    return "i8";
  }

  @Override
  public int sizeInBytes() {
    return 1;
  }
}
