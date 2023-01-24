package minijava.typecheck;

import minijava._auto.syntaxtree.Goal;
import minijava.symboltable.SymbolTable;
import minijava.typecheck.visitors.TypecheckVisitor;

public class TypeChecker {

  private final SymbolTable symbolTable;
  private final Goal ast;

  public TypeChecker(SymbolTable symbolTable, Goal ast) {
    this.symbolTable = symbolTable;
    this.ast = ast;
  }

  public void run() throws Exception {
    // System.out.println("Third pass:");
    new TypecheckVisitor(this.symbolTable).visit(this.ast);
    // System.out.println(ANSI_GREEN + "\t[OK]" + ANSI_RESET);
  }
}
