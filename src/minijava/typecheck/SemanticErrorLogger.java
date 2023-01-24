package minijava.typecheck;


import minijava._auto.syntaxtree.NodeToken;

public class SemanticErrorLogger {

  public static final String ANSI_RESET = "\u001B[0m";
  public static final String ANSI_RED = "\u001B[31m";
  public static final String ANSI_GREEN = "\u001B[32m";
  private static String filename;
  private static boolean hasError = true;

  public static void setFilename(String filename) {
    hasError = false;
    SemanticErrorLogger.filename = filename;
  }

  public static void logError(NodeToken token, String message) {
    System.err.println(
        ANSI_RED + "[Error]: " + filename + ":" + token.beginLine + ":" + token.beginColumn
            + "\n\tminijava: " + message + (message.endsWith(".") ? "" : ".") + ANSI_RESET);
    hasError = true;
  }

  public boolean hasError() {
    return hasError;
  }
}
