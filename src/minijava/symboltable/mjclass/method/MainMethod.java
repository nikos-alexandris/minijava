package minijava.symboltable.mjclass.method;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import minijava._auto.syntaxtree.NodeToken;
import minijava.symboltable.mjclass.MainClassSymbol;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public final class MainMethod implements Method {

  private final MainClassSymbol mainClass;
  private final ArrayList<LocalVariable> localVariables = new ArrayList<>();

  public MainMethod(MainClassSymbol mainClass) {
    this.mainClass = mainClass;
  }

  @Override
  public String getName() {
    return "main";
  }

  @Override
  public int getOffset() {
    return 0;
  }

  public MainClassSymbol getMainClass() {
    return mainClass;
  }

  public void addLocalVariable(NodeToken token, MJType type, String name) throws SemanticException {
    for (LocalVariable v : localVariables) {
      if (v.getName().equals(name)) {
        throw new SemanticException(token, "Redefinition of local variable.");
      }
    }
    localVariables.add(new LocalVariable(type, name));
  }

  public Optional<LocalVariable> getLocalVariable(String varName) {
    return localVariables.stream().filter(v -> v.getName().equals(varName)).findFirst();
  }

  public List<LocalVariable> getLocalVariables() {
    return Collections.unmodifiableList(localVariables);
  }
}
