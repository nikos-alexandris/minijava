package minijava.codegen.llvm.generators;

import java.io.PrintWriter;
import java.util.List;
import minijava.codegen.llvm.type.LLVMType;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.DerivedClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.method.InheritedMethod;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;

public class VTableGenerator {

  private final SymbolTable symbolTable;
  private final PrintWriter writer;

  public VTableGenerator(SymbolTable symbolTable, PrintWriter writer) {
    this.symbolTable = symbolTable;
    this.writer = writer;
  }

  public static void generateTypeSignature(UserMethod method, PrintWriter writer) {
    List<Parameter> parameters = method.getParameters();
    writer.print("(i8*");
    if (!parameters.isEmpty()) {
      writer.print(", ");
    }
    for (int j = 0; j < parameters.size(); j++) {
      writer.print(LLVMType.fromMinijavaType(parameters.get(j).getType()));
      if (j != parameters.size() - 1) {
        writer.print(", ");
      }
    }
    writer.print(")*");
  }

  public void generate() {
    for (UserClassSymbol classSymbol : symbolTable.getClasses()) {
      generateForClass(classSymbol);
    }
  }

  private void generateForClass(UserClassSymbol classSymbol) {
    List<UserMethod> methods = classSymbol.getMethods();
    writer.println(
        "@." + classSymbol.getName() + "_vtable = global [" + methods.size() + " x i8*] [");

    for (int i = 0; i < methods.size(); i++) {
      UserMethod method = methods.get(i);
      writer.print("    i8* bitcast (" + LLVMType.fromMinijavaType(method.getReturnType()) + " ");

      String className;
      if (method instanceof InheritedMethod) {
        className = ((DerivedClassSymbol) classSymbol).getSuperClass().getName();
      } else {
        className = classSymbol.getName();
      }

      VTableGenerator.generateTypeSignature(method, writer);
      writer.print(" @" + className + "." + method.getName() + " to i8*)");

      if (i != methods.size() - 1) {
        writer.println(", ");
      }
    }

    writer.println("\n]");
  }
}
