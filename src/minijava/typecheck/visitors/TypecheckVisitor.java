package minijava.typecheck.visitors;

import minijava._auto.syntaxtree.ClassDeclaration;
import minijava._auto.syntaxtree.ClassExtendsDeclaration;
import minijava._auto.syntaxtree.Goal;
import minijava._auto.syntaxtree.MainClass;
import minijava._auto.syntaxtree.MethodDeclaration;
import minijava._auto.syntaxtree.TypeDeclaration;
import minijava._auto.syntaxtree.VarDeclaration;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.method.InheritableMethod;
import minijava.symboltable.mjclass.method.MainMethod;
import minijava.symboltable.mjclass.method.Method;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;
import minijava.type.visitors.TypeVisitor;

public class TypecheckVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private ClassSymbol currClass;
  private Method currMethod;

  public TypecheckVisitor(SymbolTable table) {
    this.table = table;
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
    currClass = table.getMainClass();
    currMethod = table.getMainClass().getMainMethod();
    n.nodeListOptional.accept(this);
    new StatementVisitor(table, currClass, currMethod).visit(n.nodeListOptional1);
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
    currClass = table.getClass(n.identifier.nodeToken.toString());
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
    currClass = table.getClass(n.identifier.nodeToken.toString());
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
    /* We can safely cast to ExtendableClassSymbol since a method
     * declaration inside main would not have been accepted by the
     * parser, and we can safely unwrap the option since we already
     * have passed the second stage of method declarations. */
    currMethod = ((UserClassSymbol) currClass).getMethod(n.identifier.nodeToken.toString())
        .orElseThrow();

    n.nodeListOptional.accept(this);
    new StatementVisitor(table, currClass, currMethod).visit(n.nodeListOptional1);

    MJType returnExpType = new ExpressionVisitor(table, currClass, currMethod).visit(n.expression);
    if (!returnExpType.derivesFrom(((UserMethod) currMethod).getReturnType())) {
      throw new SemanticException(n.nodeToken4, "Return expression type " + returnExpType
          + " does not derive from the expected return type "
          + ((UserMethod) currMethod).getReturnType());
    }
  }

  /**
   * type -> Type()
   * identifier -> Identifier()
   * nodeToken -> ";"
   */
  @Override
  public void visit(VarDeclaration n) throws Exception {
    String varName = n.identifier.nodeToken.toString();
    if (currMethod instanceof MainMethod main) {
      if (varName.equals("args")) {
        throw new SemanticException(n.identifier.nodeToken,
            "Local variable " + varName + " shadows a parameter with the same name");
      }
      main.addLocalVariable(n.identifier.nodeToken, new TypeVisitor(table).visit(n.type), varName);
    } else if (currMethod instanceof InheritableMethod method) {
      // TODO add hasParameter
      if (method.getParameter(varName).isPresent()) {
        throw new SemanticException(n.identifier.nodeToken,
            "Local variable " + varName + " shadows a parameter with the same name");
      }
      method.addLocalVariable(n.identifier.nodeToken, new TypeVisitor(table).visit(n.type),
          varName);
    } else {
      throw new IllegalStateException("Unexpected type " + currMethod);
    }
  }
}
