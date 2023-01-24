package minijava.type.visitors;

import minijava._auto.syntaxtree.ArrayType;
import minijava._auto.syntaxtree.BooleanArrayType;
import minijava._auto.syntaxtree.BooleanType;
import minijava._auto.syntaxtree.Identifier;
import minijava._auto.syntaxtree.IntegerArrayType;
import minijava._auto.syntaxtree.IntegerType;
import minijava._auto.syntaxtree.Type;
import minijava._auto.visitor.GJNoArguDepthFirst;
import minijava.symboltable.SymbolTable;
import minijava.type.Array;
import minijava.type.Boolean;
import minijava.type.Integer;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public class TypeVisitor extends GJNoArguDepthFirst<MJType> {

  private final SymbolTable table;

  public TypeVisitor(SymbolTable table) {
    this.table = table;
  }

  /**
   * nodeChoice -> ArrayType() | BooleanType() | IntegerType() | Identifier()
   */
  @Override
  public MJType visit(Type n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeChoice -> BooleanArrayType() | IntegerArrayType()
   */
  @Override
  public MJType visit(ArrayType n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "boolean" nodeToken1 -> "[" nodeToken2 -> "]"
   */
  @Override
  public MJType visit(BooleanArrayType n) {
    return new Array(new Boolean());
  }

  /**
   * nodeToken -> "int" nodeToken1 -> "[" nodeToken2 -> "]"
   */
  @Override
  public MJType visit(IntegerArrayType n) {
    return new Array(new Integer());
  }

  /**
   * nodeToken -> "boolean"
   */
  @Override
  public MJType visit(BooleanType n) {
    return new Boolean();
  }

  /**
   * nodeToken -> "int"
   */
  @Override
  public MJType visit(IntegerType n) {
    return new Integer();
  }

  /**
   * nodeToken -> <IDENTIFIER>
   */
  @Override
  public MJType visit(Identifier n) throws Exception {
    String typeName = n.nodeToken.toString();
    if (!table.containsClass(typeName)) {
      throw new SemanticException(n.nodeToken,
          "Class " + typeName + " has not been declared");
    }
    return table.getClass(typeName).getType();
  }
}
