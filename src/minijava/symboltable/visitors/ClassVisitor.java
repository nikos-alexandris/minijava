package minijava.symboltable.visitors;

import minijava._auto.syntaxtree.ClassDeclaration;
import minijava._auto.syntaxtree.ClassExtendsDeclaration;
import minijava._auto.syntaxtree.Goal;
import minijava._auto.syntaxtree.MainClass;
import minijava._auto.syntaxtree.MethodDeclaration;
import minijava._auto.syntaxtree.TypeDeclaration;
import minijava._auto.syntaxtree.VarDeclaration;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.DerivedClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.visitors.TypeVisitor;

public class ClassVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private UserClassSymbol currClass;

  public ClassVisitor(SymbolTable table) {
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
    new MainClassVisitor(table, table.getMainClass());
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
    n.nodeListOptional.accept(this);
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

    ((DerivedClassSymbol) currClass).addInheritedFields();
    ((DerivedClassSymbol) currClass).addInheritedMethods();
    n.nodeListOptional.accept(this);
    n.nodeListOptional1.accept(this);
  }

  /**
   * type -> Type()
   * identifier -> Identifier()
   * nodeToken -> ";"
   */
  @Override
  public void visit(VarDeclaration n) throws Exception {
    currClass.addField(n.identifier.nodeToken, n.identifier.nodeToken.toString(),
        new TypeVisitor(table).visit(n.type));
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
    FormalParameterListVisitor v = new FormalParameterListVisitor(table);
    v.visit(n.nodeOptional);

    currClass.addMethod(n.identifier.nodeToken, new TypeVisitor(table).visit(n.type),
        n.identifier.nodeToken.toString(), v.getParameters());
  }
}
