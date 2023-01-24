package minijava;

import static minijava.typecheck.SemanticErrorLogger.ANSI_GREEN;
import static minijava.typecheck.SemanticErrorLogger.ANSI_RED;
import static minijava.typecheck.SemanticErrorLogger.ANSI_RESET;

import java.io.File;
import java.util.Objects;
import minijava._auto.syntaxtree.Goal;
import minijava.codegen.llvm.CodeGenerator;
import minijava.offsets.OffsetsWriter;
import minijava.parser.Parser;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.SymbolTableBuilder;
import minijava.typecheck.SemanticException;
import minijava.typecheck.TypeChecker;

public class Main {

  public static void main(String[] args) throws Exception {
    if (args.length == 0) {
      System.err.println("Command line args error: Expected at least one argument.");
      System.err.println("Usage: java -cp <PROJECT_DIR>/bin Main [file1] [file2] ... [fileN]");
      System.exit(1);
    }

    createOffsetsDirectory();
    createLLVMDirectory();

    for (String filename : args) {
      try {
        analyse(filename);
        System.out.println(
            ANSI_GREEN + "========== " + filename + " [PASSED] ==========" + ANSI_RESET);
        System.out.println();
      } catch (Exception e) {
        if (e.getClass() != SemanticException.class) {
          throw e;
        }
        System.out.println(
            ANSI_RED + "========== " + filename + " [FAILED] ==========" + ANSI_RESET);
        System.out.println();
      }
    }
  }

  private static void analyse(String fileName) throws Exception {
    File file = new File(fileName);

    Goal ast = new Parser(file).run(); // Parse file.
    SymbolTable symTable = new SymbolTableBuilder(ast).run(); // Build the symbol table.
    new TypeChecker(symTable, ast).run(); // Perform typechecking.
    new CodeGenerator(symTable, new File("llvm/" + file.getName() + ".ll")).run(ast); // codegen

    // Write offsets
    new OffsetsWriter(symTable, ast, new File("offsets/" + file.getName() + ".out")).run();
  }

  private static void createOffsetsDirectory() {
    File directory = new File("offsets");
    if (directory.exists()) {
      for (File f : Objects.requireNonNull(directory.listFiles())) {
        f.delete();
      }
    } else {
      directory.mkdir();
    }
  }

  private static void createLLVMDirectory() {
    File directory = new File("llvm");
    if (directory.exists()) {
      for (File f : Objects.requireNonNull(directory.listFiles())) {
        f.delete();
      }
    } else {
      directory.mkdir();
    }
  }
}