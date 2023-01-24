package minijava.codegen.llvm.generators;

import java.io.PrintWriter;
import java.util.Optional;
import minijava.codegen.llvm.LLVMRegister;
import minijava.codegen.llvm.LocalNameGenerator;
import minijava.codegen.llvm.type.LLVMType;
import minijava.codegen.llvm.type.Pointer;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.method.InheritableMethod;
import minijava.symboltable.mjclass.method.LocalVariable;
import minijava.symboltable.mjclass.method.MainMethod;
import minijava.symboltable.mjclass.method.Method;
import minijava.symboltable.mjclass.method.Parameter;

public class IdentifierGenerator {

  public LLVMRegister generate(ClassSymbol currClass, Method currMethod,
      LocalNameGenerator nameGenerator, PrintWriter writer, String name) {
    if (currClass instanceof UserClassSymbol) {
      InheritableMethod method = (InheritableMethod) currMethod;
      Optional<LocalVariable> local = method.getLocalVariable(name);
      if (local.isPresent()) {
        LocalVariable unwrapped = local.get();
        return new LLVMRegister(new Pointer(LLVMType.fromMinijavaType(unwrapped.getType())),
            "%" + name);
      }

      Optional<Parameter> parameter = method.getParameter(name);
      if (parameter.isPresent()) {
        Parameter unwrapped = parameter.get();
        return new LLVMRegister(new Pointer(LLVMType.fromMinijavaType(unwrapped.getType())),
            "%" + name);
      }

      Optional<Field> field = ((UserClassSymbol) currClass).getField(name);
      if (field.isPresent()) {
        Field unwrapped = field.get();
        LLVMType fieldType = LLVMType.fromMinijavaType(unwrapped.getType());

        String fieldPtr = nameGenerator.generateName();
        writer.println(
            "    " + fieldPtr + " = getelementptr i8, i8* %this, i32 " + (unwrapped.getOffset()
                                                                          + 8));
        String typedFieldPtr = nameGenerator.generateName();
        writer.println(
            "    " + typedFieldPtr + " = bitcast i8* " + fieldPtr + " to " + fieldType + "*");

        return new LLVMRegister(new Pointer(fieldType), typedFieldPtr);
      }

      throw new UnsupportedOperationException();
    } else {
      MainMethod method = (MainMethod) currMethod;
      Optional<LocalVariable> local = method.getLocalVariable(name);
      if (local.isPresent()) {
        LocalVariable unwrapped = local.get();
        return new LLVMRegister(new Pointer(LLVMType.fromMinijavaType(unwrapped.getType())),
            "%" + name);
      }
      throw new UnsupportedOperationException();
    }
  }
}
