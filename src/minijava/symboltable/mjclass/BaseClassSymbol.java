package minijava.symboltable.mjclass;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import minijava._auto.syntaxtree.NodeToken;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.field.OriginalField;
import minijava.symboltable.mjclass.method.OriginalMethod;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.Class;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public final class BaseClassSymbol implements UserClassSymbol {

  private final Class type;
  private final ArrayList<OriginalField> fields = new ArrayList<>();
  private final ArrayList<OriginalMethod> methods = new ArrayList<>();
  private int fieldRegionSize = 0;
  private int methodRegionSize = 0;

  private int size = 8;

  public BaseClassSymbol(String name) {
    type = new Class(name);
  }

  @Override
  public String getName() {
    return type.getName();
  }

  @Override
  public Class getType() {
    return type;
  }

  @Override
  public void addField(NodeToken token, String fieldName, MJType fieldType)
      throws SemanticException {
    if (hasField(fieldName)) {
      throw new SemanticException(token, "Redefinition of field " + fieldName);
    }
    fields.add(constructOriginalField(fieldName, fieldType));
    size += fieldType.getByteSize();
  }

  public boolean hasField(String fieldName) {
    return fields.stream().anyMatch(f -> f.getName().equals(fieldName));
  }

  @Override
  public Optional<Field> getField(String fieldName) {
    return fields.stream().filter(f -> f.getName().equals(fieldName)).findFirst()
        .map(Field.class::cast);
  }

  @Override
  public List<Field> getFields() {
    return Collections.unmodifiableList(fields);
  }

  @Override
  public void addMethod(NodeToken token, MJType returnType, String name, List<Parameter> parameters)
      throws SemanticException {
    if (hasMethod(name)) {
      throw new SemanticException(token, "Redefinition of method " + name);
    }
    methods.add(constructOriginalMethod(returnType, name, parameters));
  }

  @Override
  public boolean hasMethod(String methodName) {
    return methods.stream().anyMatch(m -> m.getName().equals(methodName));
  }

  @Override
  public Optional<UserMethod> getMethod(String methodName) {
    return methods.stream().filter(m -> m.getName().equals(methodName)).findFirst()
        .map(UserMethod.class::cast);
  }

  @Override
  public int getSizeInBytes() {
    return size;
  }

  @Override
  public List<UserMethod> getMethods() {
    return Collections.unmodifiableList(methods);
  }

  private OriginalField constructOriginalField(String fieldName, MJType fieldType) {
    OriginalField field = new OriginalField(this, fieldType, fieldName, fieldRegionSize);
    fieldRegionSize += fieldType.getByteSize();
    return field;
  }

  private OriginalMethod constructOriginalMethod(MJType returnType, String name,
      List<Parameter> parameters) {
    OriginalMethod method = new OriginalMethod(this, returnType, name, parameters,
        methodRegionSize);
    methodRegionSize += method.getByteSize();
    return method;
  }
}
