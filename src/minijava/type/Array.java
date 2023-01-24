package minijava.type;

import java.util.Objects;

public record Array(Primitive underlying) implements MJType {

  public Primitive getUnderlying() {
    return this.underlying;
  }

  @Override
  public int getByteSize() {
    return 8;
  }

  @Override
  public boolean derivesFrom(MJType type) {
    return type.getClass() == Array.class
        && ((Array) type).getUnderlying().getClass() == underlying.getClass();
  }

  @Override
  public String toString() {
    return underlying.toString() + "[]";
  }

  @Override
  public boolean equals(Object obj) {
    return obj instanceof Array array && array.underlying.equals(underlying);
  }

  @Override
  public int hashCode() {
    return Objects.hash(underlying);
  }

}
