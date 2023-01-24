package minijava.symboltable.mjclass.method;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import minijava._auto.syntaxtree.NodeToken;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public abstract sealed class InheritableMethod implements UserMethod permits OriginalMethod,
    OverriddenMethod {

  private final UserClassSymbol surroundingClass;
  private final ArrayList<Parameter> parameters;

  // TODO make set
  private final ArrayList<LocalVariable> localVariables = new ArrayList<>();

  protected InheritableMethod(UserClassSymbol surroundingClass, List<Parameter> parameters) {
    this.surroundingClass = surroundingClass;
    this.parameters = (ArrayList<Parameter>) parameters;
  }

  @Override
  public UserClassSymbol getSurroundingClass() {
    return surroundingClass;
  }

  @Override
  public Optional<Parameter> getParameter(String paramName) {
    return parameters.stream().filter(p -> p.getName().equals(paramName)).findFirst();
  }

  @Override
  public List<Parameter> getParameters() {
    return Collections.unmodifiableList(parameters);
  }

  public void addLocalVariable(NodeToken token, MJType type, String name) throws SemanticException {
    for (LocalVariable v : localVariables) {
      if (v.getName().equals(name)) {
        throw new SemanticException(token, "Redefinition of local variable.");
      }
    }
    localVariables.add(new LocalVariable(type, name));
  }

  public boolean hasLocalVariable(String varName) {
    return localVariables.stream().anyMatch(l -> l.getName().equals(varName));
  }

  public Optional<LocalVariable> getLocalVariable(String varName) {
    return localVariables.stream().filter(l -> l.getName().equals(varName)).findFirst();
  }

  @Override
  public List<LocalVariable> getLocalVariables() {
    return Collections.unmodifiableList(localVariables);
  }
}
