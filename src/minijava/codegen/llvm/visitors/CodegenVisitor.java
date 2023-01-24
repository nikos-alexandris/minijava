package minijava.codegen.llvm.visitors;

import java.io.PrintWriter;
import minijava._auto.syntaxtree.ClassDeclaration;
import minijava._auto.syntaxtree.ClassExtendsDeclaration;
import minijava._auto.syntaxtree.Goal;
import minijava._auto.syntaxtree.MainClass;
import minijava._auto.syntaxtree.MethodDeclaration;
import minijava._auto.syntaxtree.TypeDeclaration;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.codegen.llvm.LLVMRegister;
import minijava.codegen.llvm.LocalNameGenerator;
import minijava.codegen.llvm.generators.LocalVariablesGenerator;
import minijava.codegen.llvm.type.LLVMType;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;

public class CodegenVisitor extends DepthFirstVisitor {

  private final SymbolTable symbolTable;
  private final PrintWriter writer;
  private final LocalNameGenerator nameGenerator = new LocalNameGenerator();
  private ClassSymbol currClass = null;

  public CodegenVisitor(SymbolTable table, PrintWriter writer) {
    this.symbolTable = table;
    this.writer = writer;
  }

  /**
   * mainClass -> MainClass()
   * nodeListOptional -> ( TypeDeclaration() )*
   * nodeToken -> <EOF>
   */
  @Override
  public void visit(Goal n) throws Exception {
    n.mainClass.accept(this);
    n.nodeListOptional.accept(this);
  }

  /**
   * nodeToken -> "class"
   * identifier -> Identifier()
   * nodeToken1 -> "{"
   * nodeToken2 -> "public"
   * nodeToken3 -> "static"
   * nodeToken4 -> "void"
   * nodeToken5 -> "main"
   * nodeToken6 -> "("
   * nodeToken7 -> "String"
   * nodeToken8 -> "["
   * nodeToken9 -> "]"
   * identifier1 -> Identifier()
   * nodeToken10 -> ")"
   * nodeToken11 -> "{"
   * nodeListOptional -> ( VarDeclaration() )*
   * nodeListOptional1 -> ( Statement() )*
   * nodeToken12 -> "}"
   * nodeToken13 -> "}"
   */
  @Override
  public void visit(MainClass n) throws Exception {
    currClass = symbolTable.getMainClass();

    writer.println("define i32 @main() {");

    // local variables
    new LocalVariablesGenerator(symbolTable.getMainClass().getMainMethod().getLocalVariables(),
        writer).generate();

    // function body
    new StatementVisitor(symbolTable, symbolTable.getMainClass(),
        symbolTable.getMainClass().getMainMethod(), nameGenerator, writer).visit(
        n.nodeListOptional1);

    // return
    writer.println("""
            ret i32 0
        }
        """);

    nameGenerator.reset();
  }

  /**
   * nodeChoice -> ClassDeclaration()
   *       | ClassExtendsDeclaration()
   */
  @Override
  public void visit(TypeDeclaration n) throws Exception {
    n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "class"
   * identifier -> Identifier()
   * nodeToken1 -> "{"
   * nodeListOptional -> ( VarDeclaration() )*
   * nodeListOptional1 -> ( MethodDeclaration() )*
   * nodeToken2 -> "}"
   */
  @Override
  public void visit(ClassDeclaration n) throws Exception {
    currClass = symbolTable.getClass(n.identifier.nodeToken.toString());
    n.nodeListOptional1.accept(this);
  }

  /**
   * nodeToken -> "class"
   * identifier -> Identifier()
   * nodeToken1 -> "extends"
   * identifier1 -> Identifier()
   * nodeToken2 -> "{"
   * nodeListOptional -> ( VarDeclaration() )*
   * nodeListOptional1 -> ( MethodDeclaration() )*
   * nodeToken3 -> "}"
   */
  @Override
  public void visit(ClassExtendsDeclaration n) throws Exception {
    currClass = symbolTable.getClass(n.identifier.nodeToken.toString());
    n.nodeListOptional1.accept(this);
  }

  /**
   * nodeToken -> "public"
   * type -> Type()
   * identifier -> Identifier()
   * nodeToken1 -> "("
   * nodeOptional -> ( FormalParameterList() )?
   * nodeToken2 -> ")"
   * nodeToken3 -> "{"
   * nodeListOptional -> ( VarDeclaration() )*
   * nodeListOptional1 -> ( Statement() )*
   * nodeToken4 -> "return"
   * expression -> Expression()
   * nodeToken5 -> ";"
   * nodeToken6 -> "}"
   */
  @Override
  public void visit(MethodDeclaration n) throws Exception {
    UserMethod method = ((UserClassSymbol) currClass).getMethod(n.identifier.nodeToken.toString())
        .get();
    writer.print(
        "define " + LLVMType.fromMinijavaType(method.getReturnType()) + " @" + currClass.getName()
        + "." + method.getName() + "(i8* %this");
    for (Parameter parameter : method.getParameters()) {
      writer.print(
          ", " + LLVMType.fromMinijavaType(parameter.getType()) + " %." + parameter.getName());
    }
    writer.println(") {");

    for (Parameter parameter : method.getParameters()) {
      String type = LLVMType.fromMinijavaType(parameter.getType()).toString();
      String name = parameter.getName();
      writer.println("    %" + name + " = alloca " + type);
      writer.print("    store " + type + " %." + name + ", " + type + "* %" + name);
      writer.println(" ; add the parameter to the stack\n");
    }

    new LocalVariablesGenerator(method.getLocalVariables(), writer).generate();

    new StatementVisitor(symbolTable, currClass, method, nameGenerator, writer).visit(
        n.nodeListOptional1);

    LLVMRegister ret = new ExpressionVisitor(symbolTable, currClass, method, nameGenerator,
        writer).visit(n.expression).getValue(nameGenerator, writer);

    writer.println("    ret " + ret);

    writer.println("}");

    nameGenerator.reset();
  }
}
