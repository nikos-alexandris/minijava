package minijava.symboltable.visitors;

import minijava._auto.syntaxtree.ClassDeclaration;
import minijava._auto.syntaxtree.ClassExtendsDeclaration;
import minijava._auto.syntaxtree.Goal;
import minijava._auto.syntaxtree.MainClass;
import minijava._auto.syntaxtree.TypeDeclaration;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.method.MainMethod;

public class ClassDeclarationVisitor extends DepthFirstVisitor {

  private final SymbolTable table;

  public ClassDeclarationVisitor(SymbolTable table) {
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
    table.registerMainClass(n.identifier.nodeToken.toString());
    table.getMainClass().addMainMethod(new MainMethod(table.getMainClass()));
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
    table.registerClass(n.identifier.nodeToken, n.identifier.nodeToken.toString());
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
    table.registerClass(n.identifier.nodeToken, n.identifier.nodeToken.toString(),
        n.identifier1.nodeToken.toString());
  }
}
