package minijava.type;

public final class Boolean implements Primitive {

  @Override
  public int getByteSize() {
    return 1;
  }

  @Override
  public boolean derivesFrom(MJType type) {
    return type.getClass() == Boolean.class;
  }

  @Override
  public String toString() {
    return "boolean";
  }

  @Override
  public boolean equals(Object obj) {
    return obj instanceof Boolean;
  }
}
