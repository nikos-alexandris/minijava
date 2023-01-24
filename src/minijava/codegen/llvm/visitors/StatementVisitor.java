package minijava.codegen.llvm.visitors;

import java.io.PrintWriter;
import minijava._auto.syntaxtree.ArrayAssignmentStatement;
import minijava._auto.syntaxtree.AssignmentStatement;
import minijava._auto.syntaxtree.Block;
import minijava._auto.syntaxtree.IfStatement;
import minijava._auto.syntaxtree.PrintStatement;
import minijava._auto.syntaxtree.Statement;
import minijava._auto.syntaxtree.WhileStatement;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.codegen.llvm.LLVMRegister;
import minijava.codegen.llvm.LocalNameGenerator;
import minijava.codegen.llvm.generators.IdentifierGenerator;
import minijava.codegen.llvm.type.Array;
import minijava.codegen.llvm.type.LLVMType;
import minijava.codegen.llvm.type.Pointer;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.method.Method;

public class StatementVisitor extends DepthFirstVisitor {

  private final SymbolTable symbolTable;
  private final ClassSymbol currClass;
  private final Method currMethod;
  private final LocalNameGenerator nameGenerator;
  private final PrintWriter writer;

  public StatementVisitor(SymbolTable symbolTable, ClassSymbol currClass, Method currMethod,
      LocalNameGenerator nameGenerator, PrintWriter writer) {
    this.symbolTable = symbolTable;
    this.currClass = currClass;
    this.currMethod = currMethod;
    this.nameGenerator = nameGenerator;
    this.writer = writer;
  }

  /**
   * nodeChoice -> Block()
   *       | AssignmentStatement()
   *       | ArrayAssignmentStatement()
   *       | IfStatement()
   *       | WhileStatement()
   *       | PrintStatement()
   */
  @Override
  public void visit(Statement n) throws Exception {
    n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "{"
   * nodeListOptional -> ( Statement() )*
   * nodeToken1 -> "}"
   */
  @Override
  public void visit(Block n) throws Exception {
    n.nodeListOptional.accept(this);
  }

  /**
   * identifier -> Identifier()
   * nodeToken -> "="
   * expression -> Expression()
   * nodeToken1 -> ";"
   */
  @Override
  public void visit(AssignmentStatement n) throws Exception {
    LLVMRegister reg = new IdentifierGenerator().generate(currClass, currMethod, nameGenerator,
        writer, n.identifier.nodeToken.toString());
    LLVMRegister val = new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator,
        writer).visit(n.expression).getValue(nameGenerator, writer);
    writer.println("    store " + val + ", " + reg);
  }

  /**
   * identifier -> Identifier()
   * nodeToken -> "["
   * expression -> Expression()
   * nodeToken1 -> "]"
   * nodeToken2 -> "="
   * expression1 -> Expression()
   * nodeToken3 -> ";"
   */
  @Override
  public void visit(ArrayAssignmentStatement n) throws Exception {
    LLVMRegister arrayStructPtr = new IdentifierGenerator().generate(currClass, currMethod,
        nameGenerator, writer, n.identifier.nodeToken.toString()).getValue(nameGenerator, writer);
    LLVMType arrayStruct = ((Pointer) arrayStructPtr.getType()).getUnderlying();
    LLVMType underlyingType = ((Array) arrayStruct).getUnderlying();

    LLVMRegister idx = new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator,
        writer).visit(n.expression).getValue(nameGenerator, writer);

    String ltz = nameGenerator.generateName();
    writer.println(
        "    " + ltz + " = icmp slt i32 " + idx.getName() + ", 0 ; test if index is < 0");

    String negLabel = nameGenerator.generateName();
    String zpLabel = nameGenerator.generateName();
    writer.println("    br i1 " + ltz + ", label " + negLabel + ", label " + zpLabel);
    writer.println(negLabel.substring(1) + ":");
    writer.println("    call void @throw_oob()");
    writer.println("    unreachable");
    writer.println(zpLabel.substring(1) + ":");

    LLVMRegister expr = new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator,
        writer).visit(n.expression1).getValue(nameGenerator, writer);

    String lenPtr = nameGenerator.generateName();
    writer.println("    " + lenPtr + " = getelementptr %\"i32[]\", " + arrayStructPtr
                   + ", i32 0, i32 0 ; get pointer to len");
    String len = nameGenerator.generateName();
    writer.println("    " + len + " = load i32, i32* " + lenPtr + " ; load array length");

    String oobLabel = nameGenerator.generateName();
    String okLabel = nameGenerator.generateName();
    String inb = nameGenerator.generateName();

    writer.println("    " + inb + " = icmp ult i32 " + idx.getName() + ", " + len
                   + " ; test if index is < len");
    writer.println("    br i1 " + inb + ", label " + okLabel + ", label " + oobLabel);
    writer.println(oobLabel.substring(1) + ":");
    writer.println("    call void @throw_oob()");
    writer.println("    unreachable");
    writer.println(okLabel.substring(1) + ":");

    String arrayPtr = nameGenerator.generateName();
    writer.println("    " + arrayPtr + " = getelementptr " + arrayStruct + ", " + arrayStructPtr
                   + ", i32 0, i32 1 ; get pointer to array");
    String valPtr = nameGenerator.generateName();
    writer.println(
        "    " + valPtr + "  = getelementptr [0 x " + underlyingType + "], [0 x " + underlyingType
        + "]* " + arrayPtr + ", i32 0, " + idx.getType() + " " + idx.getName()
        + " ; get pointer to value");

    writer.println("    store " + expr + ", " + expr.getType() + "* " + valPtr);
  }

  /**
   * nodeToken -> "if"
   * nodeToken1 -> "("
   * expression -> Expression()
   * nodeToken2 -> ")"
   * statement -> Statement()
   * nodeToken3 -> "else"
   * statement1 -> Statement()
   */
  @Override
  public void visit(IfStatement n) throws Exception {
    LLVMRegister cond = new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator,
        writer).visit(n.expression).getValue(nameGenerator, writer);
    String labelThen = nameGenerator.generateName();
    String labelElse = nameGenerator.generateName();
    String labelEnd = nameGenerator.generateName();

    writer.println("    br " + cond + ", label " + labelThen + ", label " + labelElse);

    writer.println(labelThen.substring(1) + ":");
    n.statement.accept(this);
    writer.println("    br label " + labelEnd);

    writer.println(labelElse.substring(1) + ":");
    n.statement1.accept(this);
    writer.println("    br label " + labelEnd);

    writer.println(labelEnd.substring(1) + ":");
  }

  /**
   * nodeToken -> "while"
   * nodeToken1 -> "("
   * expression -> Expression()
   * nodeToken2 -> ")"
   * statement -> Statement()
   */
  @Override
  public void visit(WhileStatement n) throws Exception {
    String whileLabel = nameGenerator.generateName();
    String bodyLabel = nameGenerator.generateName();
    String doneLabel = nameGenerator.generateName();

    writer.println("    br label " + whileLabel);
    writer.println(whileLabel.substring(1) + ":");
    LLVMRegister cond = new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator,
        writer).visit(n.expression).getValue(nameGenerator, writer);
    writer.println("    br " + cond + ", label " + bodyLabel + ", label " + doneLabel);
    writer.println(bodyLabel.substring(1) + ":");
    new StatementVisitor(symbolTable, currClass, currMethod, nameGenerator, writer).visit(
        n.statement);
    writer.println("    br label " + whileLabel);
    writer.println(doneLabel.substring(1) + ":");
  }

  /**
   * nodeToken -> "System.out.println"
   * nodeToken1 -> "("
   * expression -> Expression()
   * nodeToken2 -> ")"
   * nodeToken3 -> ";"
   */
  @Override
  public void visit(PrintStatement n) throws Exception {
    LLVMRegister reg = new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator,
        writer).visit(n.expression).getValue(nameGenerator, writer);
    writer.println("    call void @print_int(" + reg + ") ");
  }
}
