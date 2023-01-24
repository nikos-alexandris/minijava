package minijava.symboltable.visitors;

import minijava._auto.syntaxtree.FormalParameter;
import minijava._auto.visitor.GJNoArguDepthFirst;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.type.visitors.TypeVisitor;

public class FormalParameterVisitor extends GJNoArguDepthFirst<Parameter> {

  private final SymbolTable table;

  public FormalParameterVisitor(SymbolTable table) {
    this.table = table;
  }

  /**
   * type -> Type()
   * identifier -> Identifier()
   */
  @Override
  public Parameter visit(FormalParameter n) throws Exception {
    return new Parameter(new TypeVisitor(table).visit(n.type), n.identifier.nodeToken);
  }
}
