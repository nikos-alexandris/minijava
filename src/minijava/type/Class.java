package minijava.type;

public sealed class Class implements MJType permits DerivedClass {

  protected final String name;

  public Class(String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }

  @Override
  public int getByteSize() {
    return 8;
  }

  @Override
  public boolean derivesFrom(MJType type) {
    return type.getClass() == Class.class && ((Class) type).name.equals(name);
  }

  @Override
  public String toString() {
    return getName();
  }

  @Override
  public boolean equals(Object obj) {
    return obj != null && obj.getClass() == getClass() && ((Class) obj).name.equals(name);
  }
}
