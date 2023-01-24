package minijava.symboltable.mjclass;

import java.util.List;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.Class;

public sealed interface ClassSymbol permits MainClassSymbol, UserClassSymbol {

  Class getType();

  String getName();

  List<Field> getFields();

  List<UserMethod> getMethods();
}
