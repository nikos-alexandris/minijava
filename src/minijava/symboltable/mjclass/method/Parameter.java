package minijava.symboltable.mjclass.method;

import minijava._auto.syntaxtree.NodeToken;
import minijava.type.MJType;

public final class Parameter {

  private final MJType type;
  private final NodeToken token;

  public Parameter(MJType type, NodeToken token) {
    this.token = token;
    this.type = type;
  }

  public MJType getType() {
    return type;
  }

  public String getName() {
    return token.toString();
  }

  public NodeToken getToken() {
    return token;
  }
}
