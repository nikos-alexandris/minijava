package minijava.symboltable;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import minijava._auto.syntaxtree.NodeToken;
import minijava.symboltable.mjclass.BaseClassSymbol;
import minijava.symboltable.mjclass.DerivedClassSymbol;
import minijava.symboltable.mjclass.MainClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.typecheck.SemanticException;

public class SymbolTable {

  private final Map<String, UserClassSymbol> classes = new HashMap<>();

  private MainClassSymbol main = null;

  public boolean containsClass(String className) {
    return classes.containsKey(className);
  }

  public UserClassSymbol getClass(String className) {
    return classes.get(className);
  }

  public Collection<UserClassSymbol> getClasses() {
    return classes.values();
  }

  public void registerMainClass(String className) {
    main = new MainClassSymbol(className);
  }

  public MainClassSymbol getMainClass() {
    return main;
  }

  public void registerClass(NodeToken token, String className) throws SemanticException {
    if (classes.containsKey(className) || className.equals(main.getName())) {
      throw new SemanticException(token, "Redefinition of class " + className);
    }
    classes.put(className, new BaseClassSymbol(className));
  }

  public void registerClass(NodeToken token, String className, String superName)
      throws SemanticException {
    if (classes.containsKey(className) || className.equals(main.getName())) {
      throw new SemanticException(token, "Redefinition of class " + className);
    }

    if (superName.equals(main.getName())) {
      classes.put(className, new DerivedClassSymbol(className, getMainClass()));
      return;
    }

    UserClassSymbol superClass = getClass(superName);
    if (superClass == null) {
      throw new SemanticException(token,
          "Class " + className + " tried to extend undeclared class " + superName);
    }

    classes.put(className, new DerivedClassSymbol(className, superClass));
  }
}
