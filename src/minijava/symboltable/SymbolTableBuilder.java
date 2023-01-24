package minijava.symboltable;

import static minijava.typecheck.SemanticErrorLogger.ANSI_GREEN;
import static minijava.typecheck.SemanticErrorLogger.ANSI_RED;
import static minijava.typecheck.SemanticErrorLogger.ANSI_RESET;

import minijava._auto.syntaxtree.Goal;
import minijava.symboltable.visitors.ClassDeclarationVisitor;
import minijava.symboltable.visitors.ClassVisitor;

public class SymbolTableBuilder {

  private final Goal ast;
  private final SymbolTable symbolTable = new SymbolTable();

  public SymbolTableBuilder(Goal ast) {
    this.ast = ast;
  }

  public SymbolTable run() throws Exception {
    firstPass();
    secondPass();
    return symbolTable;
  }

  private void firstPass() throws Exception {
    try {
      System.out.println("First pass:");
      new ClassDeclarationVisitor(this.symbolTable).visit(ast);
      System.out.println(ANSI_GREEN + "\t[OK]" + ANSI_RESET);
    } catch (Exception e) {
      System.err.println(ANSI_RED + "\t[Error]: " + e.getMessage() + ANSI_RESET);
      throw e;
    }
  }

  private void secondPass() throws Exception {
    try {
      System.out.println("Second pass:");
      new ClassVisitor(this.symbolTable).visit(ast);
      System.out.println(ANSI_GREEN + "\t[OK]" + ANSI_RESET);
    } catch (Exception e) {
      System.err.println(ANSI_RED + "\t[Error]: " + e.getMessage() + ANSI_RESET);
      throw e;
    }
  }
}
