package minijava.typecheck.visitors;

import java.util.Enumeration;
import minijava._auto.syntaxtree.ArrayAssignmentStatement;
import minijava._auto.syntaxtree.AssignmentStatement;
import minijava._auto.syntaxtree.Block;
import minijava._auto.syntaxtree.IfStatement;
import minijava._auto.syntaxtree.Node;
import minijava._auto.syntaxtree.NodeListOptional;
import minijava._auto.syntaxtree.PrintStatement;
import minijava._auto.syntaxtree.Statement;
import minijava._auto.syntaxtree.WhileStatement;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.method.Method;
import minijava.type.Array;
import minijava.type.Boolean;
import minijava.type.Integer;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public class StatementVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private final ClassSymbol currClass;
  private final Method currMethod;

  public StatementVisitor(SymbolTable table, ClassSymbol currClass, Method currMethod) {
    this.table = table;
    this.currClass = currClass;
    this.currMethod = currMethod;
  }

  @Override
  public void visit(NodeListOptional n) throws Exception {
    if (n.present()) {
      boolean hasError = false;
      for (Enumeration<Node> e = n.elements(); e.hasMoreElements(); ) {
        try {
          e.nextElement().accept(this);
        } catch (SemanticException error) {
          hasError = true;
        }
      }
      if (hasError) {
        throw new SemanticException();
      }
    }
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
   * identifier -> Identifier() nodeToken -> "=" expression -> Expression() nodeToken1 -> ";"
   */
  @Override
  public void visit(AssignmentStatement n) throws Exception {
    MJType varType = new ExpressionVisitor(table, currClass, currMethod).visit(n.identifier);
    MJType expType = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression);
    if (!expType.derivesFrom(varType)) {
      throw new SemanticException(n.nodeToken,
          "" + expType + " does not derive from " + varType + "");
    }
  }

  /**
   * identifier -> Identifier() nodeToken -> "[" expression -> Expression() nodeToken1 -> "]"
   * nodeToken2 -> "=" expression1 -> Expression() nodeToken3 -> ";"
   */
  @Override
  public void visit(ArrayAssignmentStatement n) throws Exception {
    MJType idType = new ExpressionVisitor(table, currClass, currMethod).visit(n.identifier);
    if (!(idType instanceof Array)) {
      throw new SemanticException(n.identifier.nodeToken,
          "Array indexing operator '[]' must be used on an array. Instead, it was used on an object of type "
          + idType);
    }
    MJType idxType = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression);
    if (!(idxType instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Array index must be of type int. Instead, it was of type " + idxType);
    }
    MJType rhsType = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression1);
    if (!rhsType.derivesFrom(((Array) idType).getUnderlying())) {
      throw new SemanticException(n.nodeToken2,
          "Incompatible types: " + rhsType + " cannot be converted to "
          + ((Array) idType).getUnderlying());
    }
  }

  /**
   * nodeToken -> "if" nodeToken1 -> "(" expression -> Expression() nodeToken2 -> ")" statement ->
   * Statement() nodeToken3 -> "else" statement1 -> Statement()
   */
  @Override
  public void visit(IfStatement n) throws Exception {
    MJType condType = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression);
    if (!(condType instanceof Boolean)) {
      throw new SemanticException(n.nodeToken,
          "If condition must be of type boolean, but type " + condType + " was found");
    }
    n.statement.accept(this);
    n.statement1.accept(this);
  }

  /**
   * nodeToken -> "while" nodeToken1 -> "(" expression -> Expression() nodeToken2 -> ")" statement
   * -> Statement()
   */
  @Override
  public void visit(WhileStatement n) throws Exception {
    MJType condType = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression);
    if (!(condType instanceof Boolean)) {
      throw new SemanticException(n.nodeToken,
          "While condition must be of type boolean, but type " + condType + " was found");
    }
    n.statement.accept(this);
  }

  /**
   * nodeToken -> "System.out.println" nodeToken1 -> "(" expression -> Expression() nodeToken2 ->
   * ")" nodeToken3 -> ";"
   */
  @Override
  public void visit(PrintStatement n) throws Exception {
    MJType type = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression);
    if (!(type instanceof Integer)) {
      throw new SemanticException(n.nodeToken, "Only ints are allowed inside print statements");
    }
  }
}
