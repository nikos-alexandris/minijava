package minijava.parser;

import static minijava.typecheck.SemanticErrorLogger.ANSI_GREEN;
import static minijava.typecheck.SemanticErrorLogger.ANSI_RED;
import static minijava.typecheck.SemanticErrorLogger.ANSI_RESET;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import minijava._auto.parser.MiniJavaParser;
import minijava._auto.parser.ParseException;
import minijava._auto.syntaxtree.Goal;
import minijava.typecheck.SemanticErrorLogger;

public class Parser {

  private final MiniJavaParser miniJavaParser;
  private final InputStream inputStream;

  public Parser(File file) throws FileNotFoundException {
    SemanticErrorLogger.setFilename(file.getAbsolutePath());
    FileInputStream stream = new FileInputStream(file);
    this.inputStream = stream;

    System.out.println("========== " + file.getName() + " ==========");

    miniJavaParser = new MiniJavaParser(stream);
  }

  public Goal run() throws ParseException, IOException {
    try {
      System.out.println("Parsing:");
      Goal ast = miniJavaParser.Goal();
      System.out.println(ANSI_GREEN + "\t[OK]" + ANSI_RESET);
      return ast;
    } catch (ParseException e) {
      System.err.println(ANSI_RED + "\t[Error]: " + e.getMessage() + ANSI_RESET);
      throw e;
    } finally {
      inputStream.close();
    }
  }
}
