package minijava.symboltable.mjclass.method;

public sealed interface Method permits MainMethod, UserMethod {

  String getName();

  int getOffset();

  default int getByteSize() {
    return 8;
  }
}
