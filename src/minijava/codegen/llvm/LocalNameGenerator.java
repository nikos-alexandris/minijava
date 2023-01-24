package minijava.codegen.llvm;

public class LocalNameGenerator {

  private int nameCount = 0;

  public String generateName() {
    return "%_" + nameCount++;
  }

  public void reset() {
    nameCount = 0;
  }
}
