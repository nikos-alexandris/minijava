package minijava.type;

public final class DerivedClass extends minijava.type.Class {

  private final minijava.type.Class superClass;

  public DerivedClass(String className, minijava.type.Class superClass) {
    super(className);
    this.superClass = superClass;
  }

  @Override
  public boolean derivesFrom(MJType type) {
    return type instanceof minijava.type.Class c && c.getName().equals(name)
        || superClass.derivesFrom(type);
  }

  public minijava.type.Class getSuperClass() {
    return superClass;
  }

  @Override
  public String toString() {
    return getName() + "(derives from " + superClass.getName() + ")";
  }

  @Override
  public boolean equals(Object obj) {
    return obj != null && obj.getClass() == getClass() && ((DerivedClass) obj).name.equals(name);
  }
}
