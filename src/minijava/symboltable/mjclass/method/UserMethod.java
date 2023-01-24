package minijava.symboltable.mjclass.method;

import java.util.List;
import java.util.Optional;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public sealed interface UserMethod extends Method permits InheritableMethod, InheritedMethod {

  UserClassSymbol getSurroundingClass();

  MJType getReturnType();

  Optional<Parameter> getParameter(String paramName);

  List<Parameter> getParameters();

  List<LocalVariable> getLocalVariables();
}
