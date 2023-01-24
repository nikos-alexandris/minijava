package minijava.typecheck.visitors;

import java.util.ArrayList;
import java.util.List;
import minijava._auto.syntaxtree.ExpressionList;
import minijava._auto.syntaxtree.ExpressionTail;
import minijava._auto.syntaxtree.ExpressionTerm;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.method.Method;
import minijava.type.MJType;

public class ExpressionListVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private final ClassSymbol currClass;
  private final Method currMethod;
  private final ArrayList<MJType> types = new ArrayList<>();

  public ExpressionListVisitor(SymbolTable table, ClassSymbol currClass, Method currMethod) {
    this.table = table;
    this.currMethod = currMethod;
    this.currClass = currClass;
  }

  public List<MJType> getTypes() {
    return types;
  }

  /**
   * expression -> Expression()
   * expressionTail -> ExpressionTail()
   */
  @Override
  public void visit(ExpressionList n) throws Exception {
    types.add(new ExpressionVisitor(table, currClass, currMethod).visit(n.expression));
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
    types.add(new ExpressionVisitor(table, currClass, currMethod).visit(n.expression));
  }
}
