package minijava.symboltable.mjclass.method;

import java.util.List;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public final class OriginalMethod extends InheritableMethod {

  private final MJType returnType;
  private final String name;
  private final int offset;

  public OriginalMethod(UserClassSymbol surroundingClass, MJType returnType, String name,
      List<Parameter> parameters, int offset) {
    super(surroundingClass, parameters);
    this.returnType = returnType;
    this.name = name;
    this.offset = offset;
  }

  @Override
  public MJType getReturnType() {
    return returnType;
  }

  @Override
  public String getName() {
    return name;
  }

  @Override
  public int getOffset() {
    return offset;
  }
}
