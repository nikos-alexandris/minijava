package minijava.typecheck.visitors;

import java.util.List;
import java.util.Optional;
import minijava._auto.syntaxtree.AllocationExpression;
import minijava._auto.syntaxtree.AndExpression;
import minijava._auto.syntaxtree.ArrayAllocationExpression;
import minijava._auto.syntaxtree.ArrayLength;
import minijava._auto.syntaxtree.ArrayLookup;
import minijava._auto.syntaxtree.BooleanArrayAllocationExpression;
import minijava._auto.syntaxtree.BracketExpression;
import minijava._auto.syntaxtree.Clause;
import minijava._auto.syntaxtree.CompareExpression;
import minijava._auto.syntaxtree.Expression;
import minijava._auto.syntaxtree.FalseLiteral;
import minijava._auto.syntaxtree.Identifier;
import minijava._auto.syntaxtree.IntegerArrayAllocationExpression;
import minijava._auto.syntaxtree.IntegerLiteral;
import minijava._auto.syntaxtree.MessageSend;
import minijava._auto.syntaxtree.MinusExpression;
import minijava._auto.syntaxtree.NotExpression;
import minijava._auto.syntaxtree.PlusExpression;
import minijava._auto.syntaxtree.PrimaryExpression;
import minijava._auto.syntaxtree.ThisExpression;
import minijava._auto.syntaxtree.TimesExpression;
import minijava._auto.syntaxtree.TrueLiteral;
import minijava._auto.visitor.GJNoArguDepthFirst;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.method.InheritableMethod;
import minijava.symboltable.mjclass.method.LocalVariable;
import minijava.symboltable.mjclass.method.MainMethod;
import minijava.symboltable.mjclass.method.Method;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.Array;
import minijava.type.Boolean;
import minijava.type.Class;
import minijava.type.Integer;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;
import minijava.typecheck.visitors.ExpressionListVisitor;

public class ExpressionVisitor extends GJNoArguDepthFirst<MJType> {

  private final SymbolTable table;
  private final ClassSymbol currClass;
  private final Method currMethod;

  public ExpressionVisitor(SymbolTable table, ClassSymbol currClass, Method currMethod) {
    this.table = table;
    this.currClass = currClass;
    this.currMethod = currMethod;
  }

  /**
   * nodeChoice -> AndExpression()
   *       | CompareExpression()
   *       | PlusExpression()
   *       | MinusExpression()
   *       | TimesExpression()
   *       | ArrayLookup()
   *       | ArrayLength()
   *       | MessageSend()
   *       | Clause()
   */
  @Override
  public MJType visit(Expression n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * clause -> Clause()
   * nodeToken -> "&&"
   * clause1 -> Clause()
   */
  @Override
  public MJType visit(AndExpression n) throws Exception {
    MJType lhs = n.clause.accept(this);
    if (!(lhs instanceof Boolean)) {
      throw new SemanticException(n.nodeToken,
          "Left hand side of '&&' must have type boolean, but here has type " + lhs);
    }
    MJType rhs = n.clause1.accept(this);
    if (!(rhs instanceof Boolean)) {
      throw new SemanticException(n.nodeToken,
          "Right hand side of '&&' must have type boolean, but here has type " + rhs);
    }
    return new Boolean();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "<"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public MJType visit(CompareExpression n) throws Exception {
    MJType lhs = n.primaryExpression.accept(this);
    if (!(lhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Left hand side of '<' must have type int, but here has type " + lhs);
    }
    MJType rhs = n.primaryExpression1.accept(this);
    if (!(rhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Right hand side of '<' must have type int, but here has type " + rhs);
    }
    return new Boolean();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "+"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public MJType visit(PlusExpression n) throws Exception {
    MJType lhs = n.primaryExpression.accept(this);
    if (!(lhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Left hand side of '+' must have type int, but here has type " + lhs);
    }
    MJType rhs = n.primaryExpression1.accept(this);
    if (!(rhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Right hand side of '+' must have type int, but here has type " + rhs);
    }
    return new Integer();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "-"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public MJType visit(MinusExpression n) throws Exception {
    MJType lhs = n.primaryExpression.accept(this);
    if (!(lhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Left hand side of '-' must have type int, but here has type " + lhs);
    }
    MJType rhs = n.primaryExpression1.accept(this);
    if (!(rhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Right hand side of '-' must have type int, but here has type " + rhs);
    }
    return new Integer();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "*"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public MJType visit(TimesExpression n) throws Exception {
    MJType lhs = n.primaryExpression.accept(this);
    if (!(lhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Left hand side of '*' must have type int, but here has type " + lhs);
    }
    MJType rhs = n.primaryExpression1.accept(this);
    if (!(rhs instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Right hand side of '*' must have type int, but here has type " + rhs);
    }
    return new Integer();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "["
   * primaryExpression1 -> PrimaryExpression()
   * nodeToken1 -> "]"
   */
  @Override
  public MJType visit(ArrayLookup n) throws Exception {
    MJType array = n.primaryExpression.accept(this);
    if (!(array instanceof Array)) {
      throw new SemanticException(n.nodeToken,
          "Array indexing operator '[]' must be used on an array. Instead, it was used on an object of type "
              + array);
    }
    MJType index = n.primaryExpression1.accept(this);
    if (!(index instanceof Integer)) {
      throw new SemanticException(n.nodeToken,
          "Array index must be of type 'int'. Instead, it was of type " + index);
    }
    return ((Array) array).getUnderlying();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "."
   * nodeToken1 -> "length"
   */
  @Override
  public MJType visit(ArrayLength n) throws Exception {
    MJType array = n.primaryExpression.accept(this);
    if (!(array instanceof Array)) {
      throw new SemanticException(n.nodeToken,
          "Array length operator '.' must be used on an array. Instead, it was used on an object of type "
              + array);
    }
    return new Integer();
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "."
   * identifier -> Identifier()
   * nodeToken1 -> "("
   * nodeOptional -> ( ExpressionList() )?
   * nodeToken2 -> ")"
   */
  @Override
  public MJType visit(MessageSend n) throws Exception {
    MJType obj = n.primaryExpression.accept(this);
    if (!(obj instanceof Class classType)) {
      throw new SemanticException(n.nodeToken,
          "Method call must be used on an object. Instead, it was used on an object of type "
              + obj);
    }

    String methodName = n.identifier.nodeToken.toString();
    if (table.getMainClass().getName().equals(classType.getName())) {
      if (table.getMainClass().getMainMethod().getName().equals(methodName)) {
        throw new SemanticException(n.nodeToken, "Can't call the main method explicitly");
      }
      throw new SemanticException(n.nodeToken,
          "Main class does not contain any method named " + methodName);
    }

    UserClassSymbol classSymbol = table.getClass(classType.getName());
    if (!classSymbol.hasMethod(methodName)) {
      throw new SemanticException(n.identifier.nodeToken,
          "Class " + classType + " does not contain a method " + methodName + "");
    }

    UserMethod method = classSymbol.getMethod(methodName).orElseThrow();
    List<Parameter> parameters = method.getParameters();

    ExpressionListVisitor visitor = new ExpressionListVisitor(table, currClass, currMethod);
    visitor.visit(n.nodeOptional);
    List<MJType> argTypes = visitor.getTypes();

    if (argTypes.size() != parameters.size()) {
      throw new SemanticException(n.nodeToken1,
          "Expected " + parameters.size() + " arguments, got " + argTypes.size());
    }
    for (int i = 0; i < argTypes.size(); i++) {
      if (!argTypes.get(i).derivesFrom(parameters.get(i).getType())) {
        throw new SemanticException(n.nodeToken1, "Argument of type " + argTypes.get(i)
            + " does not derive from matching parameter's type " + parameters.get(i).getType());
      }
    }
    return method.getReturnType();
  }

  /**
   * nodeChoice -> NotExpression()
   *       | PrimaryExpression()
   */
  @Override
  public MJType visit(Clause n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "!"
   * clause -> Clause()
   */
  @Override
  public MJType visit(NotExpression n) throws Exception {
    MJType rhs = n.clause.accept(this);
    if (!(rhs instanceof Boolean)) {
      throw new SemanticException(n.nodeToken,
          "Right hand side of '!' must have type boolean, but here has type '" + rhs + "'");
    }
    return new Boolean();
  }

  /**
   * nodeChoice -> IntegerLiteral()
   *       | TrueLiteral()
   *       | FalseLiteral()
   *       | Identifier()
   *       | ThisExpression()
   *       | ArrayAllocationExpression()
   *       | AllocationExpression()
   *       | BracketExpression()
   */
  @Override
  public MJType visit(PrimaryExpression n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> <INTEGER_LITERAL>
   */
  @Override
  public MJType visit(IntegerLiteral n) {
    return new Integer();
  }

  /**
   * nodeToken -> "true"
   */
  @Override
  public MJType visit(TrueLiteral n) {
    return new Boolean();
  }

  /**
   * nodeToken -> "false"
   */
  @Override
  public MJType visit(FalseLiteral n) {
    return new Boolean();
  }

  /**
   * nodeToken -> <IDENTIFIER>
   */
  @Override
  public MJType visit(Identifier n) throws Exception {
    String name = n.nodeToken.toString();

    if (currClass instanceof UserClassSymbol ec) {
      InheritableMethod method = (InheritableMethod) currMethod;
      Optional<LocalVariable> local = method.getLocalVariable(name);
      if (local.isPresent()) {
        return local.get().getType();
      }
      Optional<Parameter> parameter = method.getParameter(name);
      if (parameter.isPresent()) {
        return parameter.get().getType();
      }
      Optional<Field> field = ec.getField(name);
      if (field.isPresent()) {
        return field.get().getType();
      }
    } else {
      MainMethod method = (MainMethod) currMethod;
      if (name.equals("args")) {
        throw new SemanticException(n.nodeToken, "Referencing args is not allowed");
      }
      Optional<LocalVariable> local = method.getLocalVariable(name);
      if (local.isPresent()) {
        return local.get().getType();
      }
      // TODO add check for args redefinition
    }
    throw new SemanticException(n.nodeToken, "Identifier " + name + " is not defined");
  }

  /**
   * nodeToken -> "this"
   */
  @Override
  public MJType visit(ThisExpression n) {
    return currClass.getType();
  }

  /**
   * nodeChoice -> BooleanArrayAllocationExpression()
   *       | IntegerArrayAllocationExpression()
   */
  @Override
  public MJType visit(ArrayAllocationExpression n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "new"
   * nodeToken1 -> "boolean"
   * nodeToken2 -> "["
   * expression -> Expression()
   * nodeToken3 -> "]"
   */
  @Override
  public MJType visit(BooleanArrayAllocationExpression n) throws Exception {
    MJType exp = n.expression.accept(this);
    if (!(exp instanceof Integer)) {
      throw new SemanticException(n.nodeToken2,
          "boolean[] initializer expression must have type 'int' but here has type '" + exp + "'");
    }
    return new Array(new Boolean());
  }

  /**
   * nodeToken -> "new"
   * nodeToken1 -> "int"
   * nodeToken2 -> "["
   * expression -> Expression()
   * nodeToken3 -> "]"
   */
  @Override
  public MJType visit(IntegerArrayAllocationExpression n) throws Exception {
    MJType exp = n.expression.accept(this);
    if (!(exp instanceof Integer)) {
      throw new SemanticException(n.nodeToken2,
          "int[] initializer expression must have type 'int' but here has type '" + exp + "'");
    }
    return new Array(new Integer());
  }

  /**
   * nodeToken -> "new"
   * identifier -> Identifier()
   * nodeToken1 -> "("
   * nodeToken2 -> ")"
   */
  @Override
  public MJType visit(AllocationExpression n) throws Exception {
    String className = n.identifier.nodeToken.toString();
    if (!table.containsClass(className)) {
      throw new SemanticException(n.identifier.nodeToken, "Undefined class '" + className + "'");
    }
    return table.getClass(className).getType();
  }

  /**
   * nodeToken -> "("
   * expression -> Expression()
   * nodeToken1 -> ")"
   */
  @Override
  public MJType visit(BracketExpression n) throws Exception {
    return n.expression.accept(this);
  }
}