package minijava.symboltable.mjclass.method;

import minijava.type.MJType;

public record LocalVariable(MJType type, String name) {

  public MJType getType() {
    return type;
  }

  public String getName() {
    return name;
  }
}
