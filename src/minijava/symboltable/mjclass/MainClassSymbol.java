package minijava.symboltable.mjclass;

import java.util.Collections;
import java.util.List;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.method.MainMethod;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.Class;

public final class MainClassSymbol implements ClassSymbol {

  private final Class type;
  private MainMethod main = null;

  public MainClassSymbol(String name) {
    this.type = new Class(name);
  }

  public void addMainMethod(MainMethod main) {
    this.main = main;
  }

  public MainMethod getMainMethod() {
    return main;
  }

  @Override
  public Class getType() {
    return type;
  }

  @Override
  public String getName() {
    return type.getName();
  }

  @Override
  public List<Field> getFields() {
    return Collections.emptyList();
  }

  @Override
  public List<UserMethod> getMethods() {
    return Collections.emptyList();
  }
}
