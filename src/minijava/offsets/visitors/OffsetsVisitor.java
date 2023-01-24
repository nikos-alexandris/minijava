package minijava.offsets.visitors;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.List;
import minijava._auto.syntaxtree.ClassDeclaration;
import minijava._auto.syntaxtree.ClassExtendsDeclaration;
import minijava._auto.syntaxtree.Goal;
import minijava._auto.syntaxtree.TypeDeclaration;
import minijava._auto.visitor.DepthFirstVisitor;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.field.InheritedField;
import minijava.symboltable.mjclass.method.OriginalMethod;
import minijava.symboltable.mjclass.method.UserMethod;

public class OffsetsVisitor extends DepthFirstVisitor {

  private final SymbolTable table;
  private final PrintWriter writer;

  public OffsetsVisitor(SymbolTable table, PrintWriter writer) throws FileNotFoundException {
    this.table = table;
    this.writer = writer;
  }

  /**
   * mainClass -> MainClass()
   * nodeListOptional -> ( TypeDeclaration() )*
   * nodeToken -> <EOF>
   */
  @Override
  public void visit(Goal n) throws Exception {
    n.nodeListOptional.accept(this);
  }

  /**
   * nodeChoice -> ClassDeclaration()
   *       | ClassExtendsDeclaration()
   */
  @Override
  public void visit(TypeDeclaration n) throws Exception {
    n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "class"
   * identifier -> Identifier()
   * nodeToken1 -> "{"
   * nodeListOptional -> ( VarDeclaration() )*
   * nodeListOptional1 -> ( MethodDeclaration() )*
   * nodeToken2 -> "}"
   */
  @Override
  public void visit(ClassDeclaration n) throws Exception {
    UserClassSymbol c = table.getClass(n.identifier.nodeToken.toString());
    writer.println("-----------Class " + c.getName() + "-----------");
    printFields(c.getFields());
    printMethods(c.getMethods());
    writer.println();
  }

  /**
   * nodeToken -> "class"
   * identifier -> Identifier()
   * nodeToken1 -> "extends"
   * identifier1 -> Identifier()
   * nodeToken2 -> "{"
   * nodeListOptional -> ( VarDeclaration() )*
   * nodeListOptional1 -> ( MethodDeclaration() )*
   * nodeToken3 -> "}"
   */
  @Override
  public void visit(ClassExtendsDeclaration n) throws Exception {
    UserClassSymbol c = table.getClass(n.identifier.nodeToken.toString());
    writer.println("-----------Class " + c.getName() + "-----------");
    printFields(c.getFields());
    printMethods(c.getMethods());
    writer.println();
  }

  private void printFields(List<Field> fields) {
    writer.println("--Variables---");
    for (Field f : fields) {
      if (f instanceof InheritedField) {
        continue;
      }
      printField(f);
    }
  }

  private void printField(Field f) {
    writer.println(f.getSurroundingClass().getName() + "." + f.getName() + " : " + f.getOffset());
  }

  private void printMethods(List<UserMethod> methods) {
    writer.println("---Methods---");
    for (UserMethod m : methods) {
      if (!(m instanceof OriginalMethod)) {
        continue;
      }
      printMethod(m);
    }
  }

  private void printMethod(UserMethod f) {
    writer.println(f.getSurroundingClass().getName() + "." + f.getName() + " : " + f.getOffset());
  }
}
