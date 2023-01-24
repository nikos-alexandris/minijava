package minijava.codegen.llvm.type;

public sealed interface Primitive extends LLVMType permits Integer, Boolean, Byte {

  int sizeInBytes();
}
