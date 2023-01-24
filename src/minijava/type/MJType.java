package minijava.type;

public sealed interface MJType permits Primitive, Array, Class {

  int getByteSize();

  boolean derivesFrom(MJType type);
}
