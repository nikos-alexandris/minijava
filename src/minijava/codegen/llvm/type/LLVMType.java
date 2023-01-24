package minijava.codegen.llvm.type;

public sealed interface LLVMType permits Pointer, Array, Class, Primitive {

  static LLVMType fromMinijavaType(minijava.type.MJType t) {
    if (t instanceof minijava.type.Primitive p) {
      return fromMinijavaType(p);
    } else if (t instanceof minijava.type.Array a) {
      return fromMinijavaType(a);
    } else if (t instanceof minijava.type.Class c) {
      return fromMinijavaType(c);
    } else {
      throw new UnsupportedOperationException();
    }
  }

  static Primitive fromMinijavaType(minijava.type.Primitive p) {
    if (p instanceof minijava.type.Integer) {
      return new minijava.codegen.llvm.type.Integer();
    } else if (p instanceof minijava.type.Boolean) {
      return new minijava.codegen.llvm.type.Boolean();
    } else {
      throw new UnsupportedOperationException();
    }
  }

  static Pointer fromMinijavaType(minijava.type.Array a) {
    return new Pointer(new Array(LLVMType.fromMinijavaType(a.getUnderlying())));
  }

  static Class fromMinijavaType(minijava.type.Class c) {
    return new Class(c.getName());
  }
}
