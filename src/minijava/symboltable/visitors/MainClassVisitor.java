package minijava.symboltable.visitors;

import minijava._auto.syntaxtree.VarDeclaration;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.MainClassSymbol;
import minijava.type.visitors.TypeVisitor;

public class MainClassVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private final MainClassSymbol main;

  public MainClassVisitor(SymbolTable table, MainClassSymbol main) {
    this.table = table;
    this.main = main;
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
  public void visit(minijava._auto.syntaxtree.MainClass n) throws Exception {
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
    main.getMainMethod()
        .addLocalVariable(n.identifier.nodeToken, new TypeVisitor(table).visit(n.type),
            n.identifier.nodeToken.toString());
  }
}
