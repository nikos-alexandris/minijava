package minijava.typecheck;

import minijava._auto.syntaxtree.NodeToken;

public class SemanticException extends Exception {

  public SemanticException(NodeToken token, String message) {
    super();
    SemanticErrorLogger.logError(token, message);
  }

  public SemanticException() {
    super();
  }
}
