package minijava.symboltable.mjclass.field;

import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public final class InheritedField implements Field {

  private final OriginalField originalField;

  public InheritedField(OriginalField originalField) {
    this.originalField = originalField;
  }

  public OriginalField getOriginalField() {
    return originalField;
  }

  @Override
  public UserClassSymbol getSurroundingClass() {
    return originalField.getSurroundingClass();
  }

  @Override
  public String getName() {
    return originalField.getName();
  }

  @Override
  public MJType getType() {
    return originalField.getType();
  }

  @Override
  public int getOffset() {
    return originalField.getOffset();
  }
}
