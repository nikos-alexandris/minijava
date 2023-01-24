package minijava.type;

public final class Integer implements Primitive {

  @Override
  public int getByteSize() {
    return 4;
  }

  @Override
  public boolean derivesFrom(MJType type) {
    return type.getClass() == Integer.class;
  }

  @Override
  public String toString() {
    return "int";
  }

  @Override
  public boolean equals(Object obj) {
    return obj instanceof Integer;
  }
}
