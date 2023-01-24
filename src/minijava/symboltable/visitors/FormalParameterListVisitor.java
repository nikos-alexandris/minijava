package minijava.symboltable.visitors;

import java.util.ArrayList;
import java.util.List;
import minijava._auto.syntaxtree.FormalParameterList;
import minijava._auto.syntaxtree.FormalParameterTail;
import minijava._auto.syntaxtree.FormalParameterTerm;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.typecheck.SemanticException;

public class FormalParameterListVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private final ArrayList<Parameter> parameters = new ArrayList<>();

  public FormalParameterListVisitor(SymbolTable table) {
    this.table = table;
  }

  public List<Parameter> getParameters() {
    return parameters;
  }

  /**
   * formalParameter -> FormalParameter()
   * formalParameterTail -> FormalParameterTail()
   */
  @Override
  public void visit(FormalParameterList n) throws Exception {
    Parameter parameter = new FormalParameterVisitor(table).visit(n.formalParameter);
    for (Parameter p : parameters) {
      if (p.getName().equals(parameter.getName())) {
        throw new SemanticException(n.formalParameter.identifier.nodeToken,
            "Formal parameter " + parameter.getName() + " is defined more than once.");
      }
    }
    parameters.add(parameter);
    n.formalParameterTail.accept(this);
  }

  /**
   * nodeListOptional -> ( FormalParameterTerm() )*
   */
  @Override
  public void visit(FormalParameterTail n) throws Exception {
    n.nodeListOptional.accept(this);
  }

  /**
   * nodeToken -> ","
   * formalParameter -> FormalParameter()
   */
  @Override
  public void visit(FormalParameterTerm n) throws Exception {
    parameters.add(new FormalParameterVisitor(table).visit(n.formalParameter));
  }
}
