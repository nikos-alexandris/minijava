package minijava.codegen.llvm.visitors;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import minijava._auto.syntaxtree.ExpressionList;
import minijava._auto.syntaxtree.ExpressionTail;
import minijava._auto.syntaxtree.ExpressionTerm;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.codegen.llvm.LLVMRegister;
import minijava.codegen.llvm.LocalNameGenerator;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.method.Method;

public class ExpressionListVisitor extends DepthFirstVisitor {

  private final SymbolTable symbolTable;
  private final ClassSymbol currClass;
  private final Method currMethod;
  private final LocalNameGenerator nameGenerator;
  private final PrintWriter writer;
  private final ArrayList<LLVMRegister> values = new ArrayList<>();

  public ExpressionListVisitor(SymbolTable symbolTable, ClassSymbol currClass, Method currMethod,
      LocalNameGenerator nameGenerator, PrintWriter writer) {
    this.symbolTable = symbolTable;
    this.currClass = currClass;
    this.currMethod = currMethod;
    this.nameGenerator = nameGenerator;
    this.writer = writer;
  }

  public List<LLVMRegister> getValues() {
    return Collections.unmodifiableList(values);
  }

  /**
   * expression -> Expression()
   * expressionTail -> ExpressionTail()
   */
  @Override
  public void visit(ExpressionList n) throws Exception {
    values.add(
        new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator, writer).visit(
            n.expression).getValue(nameGenerator, writer));
    n.expressionTail.accept(this);
  }

  /**
   * nodeListOptional -> ( ExpressionTerm() )*
   */
  @Override
  public void visit(ExpressionTail n) throws Exception {
    n.nodeListOptional.accept(this);
  }

  /**
   * nodeToken -> ","
   * expression -> Expression()
   */
  @Override
  public void visit(ExpressionTerm n) throws Exception {
    values.add(
        new ExpressionVisitor(symbolTable, currClass, currMethod, nameGenerator, writer).visit(
            n.expression).getValue(nameGenerator, writer));
  }

}
