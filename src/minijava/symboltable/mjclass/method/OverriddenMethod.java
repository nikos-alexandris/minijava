package minijava.symboltable.mjclass.method;

import java.util.List;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public final class OverriddenMethod extends InheritableMethod {

  private final InheritableMethod inheritedMethod;

  public OverriddenMethod(UserClassSymbol surroundingClass, InheritableMethod inheritedMethod,
      List<Parameter> parameters) {
    super(surroundingClass, parameters);
    this.inheritedMethod = inheritedMethod;
  }

  public InheritableMethod getInheritedMethod() {
    return inheritedMethod;
  }

  @Override
  public MJType getReturnType() {
    return inheritedMethod.getReturnType();
  }

  @Override
  public String getName() {
    return inheritedMethod.getName();
  }

  @Override
  public int getOffset() {
    return inheritedMethod.getOffset();
  }
}
