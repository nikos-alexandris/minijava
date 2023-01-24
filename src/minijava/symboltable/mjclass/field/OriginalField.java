package minijava.symboltable.mjclass.field;

import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public final class OriginalField implements Field {

  private final UserClassSymbol surroundingClass;
  private final String name;
  private final MJType type;

  private final int offset;

  public OriginalField(UserClassSymbol surroundingClass, MJType type, String name,
      int offset) {
    this.surroundingClass = surroundingClass;
    this.name = name;
    this.type = type;
    this.offset = offset;
  }

  @Override
  public UserClassSymbol getSurroundingClass() {
    return surroundingClass;
  }


  @Override
  public String getName() {
    return name;
  }

  @Override
  public MJType getType() {
    return type;
  }

  @Override
  public int getOffset() {
    return offset;
  }
}
