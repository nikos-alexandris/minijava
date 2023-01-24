package minijava.symboltable.mjclass.field;


import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.type.MJType;

public sealed interface Field permits OriginalField, InheritedField {

  UserClassSymbol getSurroundingClass();

  String getName();

  MJType getType();

  int getOffset();
}
