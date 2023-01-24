package minijava.offsets;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import minijava._auto.syntaxtree.Goal;
import minijava.offsets.visitors.OffsetsVisitor;
import minijava.symboltable.SymbolTable;

public class OffsetsWriter {

  private final OffsetsVisitor visitor;
  private final Goal ast;
  private final PrintWriter writer;

  public OffsetsWriter(SymbolTable table, Goal ast, File file) throws FileNotFoundException {
    this.writer = new PrintWriter(new FileOutputStream(file), true);
    this.visitor = new OffsetsVisitor(table, this.writer);
    this.ast = ast;
  }

  public void run() throws Exception {
    visitor.visit(ast);
    writer.close();
  }
}
