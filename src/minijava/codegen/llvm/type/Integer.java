package minijava.codegen.llvm.type;

public final class Integer implements Primitive {

  @Override
  public String toString() {
    return "i32";
  }

  @Override
  public int sizeInBytes() {
    return 4;
  }
}
