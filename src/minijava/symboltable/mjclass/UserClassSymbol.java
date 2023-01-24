package minijava.symboltable.mjclass;

import java.util.List;
import java.util.Optional;
import minijava._auto.syntaxtree.NodeToken;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public sealed interface UserClassSymbol extends ClassSymbol permits BaseClassSymbol,
    DerivedClassSymbol {

  Optional<Field> getField(String fieldName);

  void addField(NodeToken token, String fieldName, MJType fieldType) throws SemanticException;

  void addMethod(NodeToken token, MJType returnType, String name, List<Parameter> parameters)
      throws SemanticException;

  boolean hasMethod(String methodName);

  Optional<UserMethod> getMethod(String methodName);

  int getSizeInBytes();
}
