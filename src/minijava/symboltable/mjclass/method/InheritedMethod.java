package minijava.symboltable.mjclass.method;

import java.util.List;
import java.util.Optional;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public final class InheritedMethod implements UserMethod {

  private final InheritableMethod enclosedMethod;

  public InheritedMethod(InheritableMethod inheritedMethod) {
    this.enclosedMethod = inheritedMethod;
  }

  public InheritableMethod getEnclosedMethod() {
    return enclosedMethod;
  }

  @Override
  public String getName() {
    return enclosedMethod.getName();
  }

  @Override
  public int getOffset() {
    return enclosedMethod.getOffset();
  }

  @Override
  public UserClassSymbol getSurroundingClass() {
    return enclosedMethod.getSurroundingClass();
  }

  @Override
  public MJType getReturnType() {
    return enclosedMethod.getReturnType();
  }

  @Override
  public Optional<Parameter> getParameter(String paramName) {
    return enclosedMethod.getParameter(paramName);
  }

  @Override
  public List<Parameter> getParameters() {
    return enclosedMethod.getParameters();
  }

  @Override
  public List<LocalVariable> getLocalVariables() {
    return enclosedMethod.getLocalVariables();
  }
}
