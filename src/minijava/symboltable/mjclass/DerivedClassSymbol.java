package minijava.symboltable.mjclass;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.ListIterator;
import java.util.Optional;
import minijava._auto.syntaxtree.NodeToken;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.field.InheritedField;
import minijava.symboltable.mjclass.field.OriginalField;
import minijava.symboltable.mjclass.method.InheritableMethod;
import minijava.symboltable.mjclass.method.InheritedMethod;
import minijava.symboltable.mjclass.method.Method;
import minijava.symboltable.mjclass.method.OriginalMethod;
import minijava.symboltable.mjclass.method.OverriddenMethod;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;
import minijava.type.Class;
import minijava.type.MJType;
import minijava.typecheck.SemanticException;

public final class DerivedClassSymbol implements UserClassSymbol {

  private final ClassSymbol superClass;
  private final minijava.type.DerivedClass type;

  private final ArrayList<Field> fields = new ArrayList<>();
  private final ArrayList<UserMethod> methods = new ArrayList<>();
  private int fieldRegionSize = 0;
  private int methodRegionSize = 0;

  private int size = 8;

  public DerivedClassSymbol(String name, ClassSymbol superClass) {
    this.superClass = superClass;
    this.type = new minijava.type.DerivedClass(name, superClass.getType());
  }

  @Override
  public String getName() {
    return type.getName();
  }

  @Override
  public Class getType() {
    return type;
  }

  public ClassSymbol getSuperClass() {
    return superClass;
  }

  public void addInheritedFields() {
    for (Field field : getSuperClass().getFields()) {
      if (field instanceof InheritedField inherited) {
        fields.add(constructInheritedField(inherited));
      } else if (field instanceof OriginalField original) {
        fields.add(constructInheritedField(original));
      }
      size += field.getType().getByteSize();
    }
  }

  @Override
  public void addField(NodeToken token, String fieldName, MJType fieldType)
      throws SemanticException {
    ListIterator<Field> it = fields.listIterator(fields.size());
    while (it.hasPrevious()) {
      Field f = it.previous();
      if (f.getName().equals(fieldName)) {
        if (f instanceof InheritedField) {
          break;
        }
        throw new SemanticException(token, "Redefinition of field " + fieldName);
      }
    }
    fields.add(constructOriginalField(fieldType, fieldName));
    size += fieldType.getByteSize();
  }

  public boolean hasField(String fieldName) {
    return fields.stream().anyMatch(f -> f.getName().equals(fieldName));
  }

  public Optional<Field> getField(String fieldName) {
    return fields.stream().filter(f -> f.getName().equals(fieldName)).findFirst();
  }

  @Override
  public List<Field> getFields() {
    return Collections.unmodifiableList(fields);
  }

  public void addInheritedMethods() {
    for (UserMethod method : getSuperClass().getMethods()) {
      if (method instanceof OriginalMethod original) {
        methods.add(constructInheritedMethod(original));
      } else if (method instanceof InheritedMethod inherited) {
        methods.add(constructInheritedMethod(inherited.getEnclosedMethod()));
      } else if (method instanceof OverriddenMethod overridden) {
        methods.add(constructInheritedMethod(overridden));
      }
    }
  }

  @Override
  public void addMethod(NodeToken token, MJType returnType, String methodName,
      List<Parameter> parameters) throws SemanticException {
    ListIterator<UserMethod> it = methods.listIterator();
    while (it.hasNext()) {
      Method m = it.next();
      if (m.getName().equals(methodName)) {
        if (m instanceof InheritedMethod inherited) {
          it.set(constructOverriddenMethod(token, inherited, returnType, parameters));
          return;
        } else {
          throw new SemanticException(token, "Redefinition of method " + methodName);
        }
      }
    }
    methods.add(constructOriginalMethod(returnType, methodName, parameters));
  }

  @Override
  public boolean hasMethod(String methodName) {
    return methods.stream().anyMatch(m -> m.getName().equals(methodName));
  }

  @Override
  public Optional<UserMethod> getMethod(String methodName) {
    return methods.stream().filter(m -> m.getName().equals(methodName)).findFirst();
  }

  @Override
  public int getSizeInBytes() {
    return size;
  }

  public List<UserMethod> getMethods() {
    return Collections.unmodifiableList(methods);
  }

  private InheritedField constructInheritedField(OriginalField original) {
    InheritedField newField = new InheritedField(original);
    fieldRegionSize += newField.getOriginalField().getType().getByteSize();
    return newField;
  }

  private InheritedField constructInheritedField(InheritedField inherited) {
    InheritedField newField = new InheritedField(inherited.getOriginalField());
    fieldRegionSize += newField.getOriginalField().getType().getByteSize();
    return newField;
  }

  private OriginalField constructOriginalField(MJType type, String name) {
    OriginalField newField = new OriginalField(this, type, name, fieldRegionSize);
    fieldRegionSize += newField.getType().getByteSize();
    return newField;
  }

  private OriginalMethod constructOriginalMethod(MJType type, String name,
      List<Parameter> parameters) {
    OriginalMethod newMethod = new OriginalMethod(this, type, name, parameters, methodRegionSize);
    methodRegionSize += newMethod.getByteSize();
    return newMethod;
  }

  private InheritedMethod constructInheritedMethod(InheritableMethod original) {
    InheritedMethod newMethod = new InheritedMethod(original);
    methodRegionSize += newMethod.getByteSize();
    return newMethod;
  }

  private OverriddenMethod constructOverriddenMethod(NodeToken token, InheritedMethod inherited,
      MJType returnType, List<Parameter> parameters) throws SemanticException {
    if (!inherited.getReturnType().equals(returnType)) {
      throw new SemanticException(token,
          "Return type " + returnType + " of overridden method does not match the expected type "
          + inherited.getReturnType());
    }
    if (inherited.getParameters().size() != parameters.size()) {
      throw new SemanticException(token,
          "Overriding method must have the same number of parameters with the overridden method.");
    }
    for (int i = 0; i < inherited.getParameters().size(); i++) {
      if (!inherited.getParameters().get(i).getType().equals(parameters.get(i).getType())) {
        throw new SemanticException(token,
            "Formal parameter number " + i + " has type " + parameters.get(i).getType()
            + ", but type " + inherited.getParameters().get(i).getType() + " was expected.");
      }
    }
    return new OverriddenMethod(this, inherited.getEnclosedMethod(), parameters);
  }

  private boolean canOverride(InheritedMethod method, MJType returnType,
      List<Parameter> parameters) {
    InheritableMethod inherited = method.getEnclosedMethod();
    if (!inherited.getReturnType().equals(returnType)) {
      return false;
    }
    if (inherited.getParameters().size() != parameters.size()) {
      return false;
    }
    for (int i = 0; i < inherited.getParameters().size(); i++) {
      if (!inherited.getParameters().get(i).getType().equals(parameters.get(i).getType())) {
        return false;
      }
    }
    return true;
  }
}
