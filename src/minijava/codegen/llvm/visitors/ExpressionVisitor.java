package minijava.codegen.llvm.visitors;

import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;
import minijava._auto.syntaxtree.AllocationExpression;
import minijava._auto.syntaxtree.AndExpression;
import minijava._auto.syntaxtree.ArrayAllocationExpression;
import minijava._auto.syntaxtree.ArrayLength;
import minijava._auto.syntaxtree.ArrayLookup;
import minijava._auto.syntaxtree.BooleanArrayAllocationExpression;
import minijava._auto.syntaxtree.BracketExpression;
import minijava._auto.syntaxtree.Clause;
import minijava._auto.syntaxtree.CompareExpression;
import minijava._auto.syntaxtree.Expression;
import minijava._auto.syntaxtree.FalseLiteral;
import minijava._auto.syntaxtree.Identifier;
import minijava._auto.syntaxtree.IntegerArrayAllocationExpression;
import minijava._auto.syntaxtree.IntegerLiteral;
import minijava._auto.syntaxtree.MessageSend;
import minijava._auto.syntaxtree.MinusExpression;
import minijava._auto.syntaxtree.NotExpression;
import minijava._auto.syntaxtree.PlusExpression;
import minijava._auto.syntaxtree.PrimaryExpression;
import minijava._auto.syntaxtree.ThisExpression;
import minijava._auto.syntaxtree.TimesExpression;
import minijava._auto.syntaxtree.TrueLiteral;
import minijava._auto.visitor.GJNoArguDepthFirst;
import minijava.codegen.llvm.LLVMRegister;
import minijava.codegen.llvm.LocalNameGenerator;
import minijava.codegen.llvm.generators.VTableGenerator;
import minijava.codegen.llvm.type.Array;
import minijava.codegen.llvm.type.Boolean;
import minijava.codegen.llvm.type.Class;
import minijava.codegen.llvm.type.Integer;
import minijava.codegen.llvm.type.LLVMType;
import minijava.codegen.llvm.type.Pointer;
import minijava.symboltable.SymbolTable;
import minijava.symboltable.mjclass.ClassSymbol;
import minijava.symboltable.mjclass.UserClassSymbol;
import minijava.symboltable.mjclass.field.Field;
import minijava.symboltable.mjclass.method.InheritableMethod;
import minijava.symboltable.mjclass.method.LocalVariable;
import minijava.symboltable.mjclass.method.MainMethod;
import minijava.symboltable.mjclass.method.Method;
import minijava.symboltable.mjclass.method.Parameter;
import minijava.symboltable.mjclass.method.UserMethod;

public class ExpressionVisitor extends GJNoArguDepthFirst<LLVMRegister> {


  private final SymbolTable symbolTable;
  private final ClassSymbol currClass;
  private final Method currMethod;
  private final LocalNameGenerator nameGenerator;
  private final PrintWriter writer;

  public ExpressionVisitor(SymbolTable symbolTable, ClassSymbol currClass, Method currMethod,
      LocalNameGenerator nameGenerator, PrintWriter writer) {
    this.symbolTable = symbolTable;
    this.currClass = currClass;
    this.currMethod = currMethod;
    this.nameGenerator = nameGenerator;
    this.writer = writer;
  }

  /**
   * nodeChoice -> AndExpression() // DONE
   *       | CompareExpression() // DONE
   *       | PlusExpression() // DONE
   *       | MinusExpression() // DONE
   *       | TimesExpression() // DONE
   *       | ArrayLookup() // DONE
   *       | ArrayLength() // DONE
   *       | MessageSend() // DONE
   *       | Clause()
   */
  @Override
  public LLVMRegister visit(Expression n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * clause -> Clause()
   * nodeToken -> "&&"
   * clause1 -> Clause()
   */
  @Override
  public LLVMRegister visit(AndExpression n) throws Exception {
    String startLabel = nameGenerator.generateName();
    String endLabel = nameGenerator.generateName();

    writer.println("    br label " + startLabel);
    writer.println(startLabel.substring(1) + ":");

    LLVMRegister l = n.clause.accept(this).getValue(nameGenerator, writer);
    String trueLabel = nameGenerator.generateName();
    writer.println("    br i1 " + l.getName() + ", label " + trueLabel + ", label " + endLabel);

    writer.println(trueLabel.substring(1) + ":");
    LLVMRegister r = n.clause1.accept(this).getValue(nameGenerator, writer);
    writer.println("    br label " + endLabel);

    writer.println(endLabel.substring(1) + ":");

    String result = nameGenerator.generateName();
    writer.println(
        "    " + result + " = phi i1 [ false, " + startLabel + " ], [ " + r.getName() + ", "
        + trueLabel + " ]");

    return new LLVMRegister(new Boolean(), result);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "<"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public LLVMRegister visit(CompareExpression n) throws Exception {
    LLVMRegister l = n.primaryExpression.accept(this).getValue(nameGenerator, writer);
    LLVMRegister r = n.primaryExpression1.accept(this).getValue(nameGenerator, writer);
    String result = nameGenerator.generateName();
    writer.println("    " + result + " = " + "icmp slt i32 " + l.getName() + ", " + r.getName());
    return new LLVMRegister(new Boolean(), result);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "+"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public LLVMRegister visit(PlusExpression n) throws Exception {
    LLVMRegister l = n.primaryExpression.accept(this).getValue(nameGenerator, writer);
    LLVMRegister r = n.primaryExpression1.accept(this).getValue(nameGenerator, writer);
    String result = nameGenerator.generateName();
    writer.println("    " + result + " = " + "add i32 " + l.getName() + ", " + r.getName());
    return new LLVMRegister(new Integer(), result);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "-"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public LLVMRegister visit(MinusExpression n) throws Exception {
    LLVMRegister l = n.primaryExpression.accept(this).getValue(nameGenerator, writer);
    LLVMRegister r = n.primaryExpression1.accept(this).getValue(nameGenerator, writer);
    String result = nameGenerator.generateName();
    writer.println("    " + result + " = " + "sub i32 " + l.getName() + ", " + r.getName());
    return new LLVMRegister(new Integer(), result);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "*"
   * primaryExpression1 -> PrimaryExpression()
   */
  @Override
  public LLVMRegister visit(TimesExpression n) throws Exception {
    LLVMRegister l = n.primaryExpression.accept(this).getValue(nameGenerator, writer);
    LLVMRegister r = n.primaryExpression1.accept(this).getValue(nameGenerator, writer);
    String result = nameGenerator.generateName();
    writer.println("    " + result + " = " + "mul i32 " + l.getName() + ", " + r.getName());
    return new LLVMRegister(new Integer(), result);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "["
   * primaryExpression1 -> PrimaryExpression()
   * nodeToken1 -> "]"
   */
  @Override
  public LLVMRegister visit(ArrayLookup n) throws Exception {
    LLVMRegister arrayStructAllocPtr = n.primaryExpression.accept(this);
    LLVMRegister arrayStructPtr = arrayStructAllocPtr.getValue(nameGenerator, writer);
    LLVMType arrayStruct = ((Pointer) arrayStructPtr.getType()).getUnderlying();
    LLVMType underlyingType = ((Array) arrayStruct).getUnderlying();

    LLVMRegister idx = n.primaryExpression1.accept(this).getValue(nameGenerator, writer);

    String ltz = nameGenerator.generateName();
    writer.println(
        "    " + ltz + " = icmp slt i32 " + idx.getName() + ", 0 ; test if index is < 0");

    String negLabel = nameGenerator.generateName();
    String zpLabel = nameGenerator.generateName();
    writer.println("    br i1 " + ltz + ", label " + negLabel + ", label " + zpLabel);
    writer.println(negLabel.substring(1) + ":");
    writer.println("    call void @throw_oob()");
    writer.println("    unreachable");
    writer.println(zpLabel.substring(1) + ":");

    String lenPtr = nameGenerator.generateName();
    writer.println("    " + lenPtr + " = getelementptr " + arrayStruct + ", " + arrayStructPtr
                   + ", i32 0, i32 0 ; get pointer to len");
    String len = nameGenerator.generateName();
    writer.println("    " + len + " = load i32, i32* " + lenPtr + " ; load len");

    String oobLabel = nameGenerator.generateName();
    String okLabel = nameGenerator.generateName();
    String inb = nameGenerator.generateName();

    writer.println("    " + inb + " = icmp ult i32 " + idx.getName() + ", " + len
                   + " ; test if index is < len");

    writer.println("    br i1 " + inb + ", label " + okLabel + ", label " + oobLabel);
    writer.println(oobLabel.substring(1) + ":");
    writer.println("    call void @throw_oob()");
    writer.println("    unreachable");
    writer.println(okLabel.substring(1) + ":");

    String arrayPtr = nameGenerator.generateName();
    writer.println("    " + arrayPtr + " = getelementptr " + arrayStruct + ", " + arrayStructPtr
                   + ", i32 0, i32 1 ; get pointer to array");

    String resultPtr = nameGenerator.generateName();
    writer.println("    " + resultPtr + "  = getelementptr [0 x " + underlyingType + "], [0 x "
                   + underlyingType + "]* " + arrayPtr + ", i32 0, " + idx.getType() + " "
                   + idx.getName() + " ; get pointer to value");

    String result = nameGenerator.generateName();
    writer.println(
        "    " + result + " = load " + underlyingType + ", " + underlyingType + "* " + resultPtr
        + " ; load result");

    return new LLVMRegister(underlyingType, result);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "."
   * nodeToken1 -> "length"
   */
  @Override
  public LLVMRegister visit(ArrayLength n) throws Exception {
    LLVMRegister arrayStructPtr = n.primaryExpression.accept(this).getValue(nameGenerator, writer);
    LLVMType arrayStruct = ((Pointer) arrayStructPtr.getType()).getUnderlying();

    String lenPtr = nameGenerator.generateName();
    writer.println("    " + lenPtr + " = getelementptr " + arrayStruct + ", " + arrayStruct + "* "
                   + arrayStructPtr.getName() + ", i32 0, i32 0 ; get pointer to len");
    String len = nameGenerator.generateName();
    writer.println("    " + len + " = load i32, i32* " + lenPtr + " ; load len");

    return new LLVMRegister(LLVMType.fromMinijavaType(new minijava.type.Integer()), len);
  }

  /**
   * primaryExpression -> PrimaryExpression()
   * nodeToken -> "."
   * identifier -> Identifier()
   * nodeToken1 -> "("
   * nodeOptional -> ( ExpressionList() )?
   * nodeToken2 -> ")"
   */
  @Override
  public LLVMRegister visit(MessageSend n) throws Exception {
    LLVMRegister classReg = n.primaryExpression.accept(this).getValue(nameGenerator, writer);

    UserMethod method = symbolTable.getClass(((Class) classReg.getType()).getClassName())
        .getMethod(n.identifier.nodeToken.toString()).get();

    int offset = method.getOffset() / 8;

    String functionName = classReg.getName() + "." + method.getName();
    writer.println("    ; " + functionName + " : " + offset);
    String classPtr = nameGenerator.generateName();
    writer.println("    " + classPtr + " = bitcast i8* " + classReg.getName() + " to i8***");
    String vTable = nameGenerator.generateName();
    writer.println("    " + vTable + " = load i8**, i8*** " + classPtr);
    String vTableOffPtr = nameGenerator.generateName();
    writer.println(
        "    " + vTableOffPtr + " = getelementptr i8*, i8** " + vTable + ", i32 " + offset);
    String functionPtr = nameGenerator.generateName();
    writer.println("    " + functionPtr + " = load i8*, i8** " + vTableOffPtr);
    String typedFunction = nameGenerator.generateName();
    writer.print("    " + typedFunction + " = bitcast i8* " + functionPtr + " to ");

    LLVMType returnType = LLVMType.fromMinijavaType(method.getReturnType());
    writer.write(returnType + " ");
    VTableGenerator.generateTypeSignature(method, writer);
    writer.println();

    ExpressionListVisitor args = new ExpressionListVisitor(symbolTable, currClass, currMethod,
        nameGenerator, writer);
    args.visit(n.nodeOptional);
    List<LLVMRegister> values = args.getValues();

    String result = nameGenerator.generateName();
    writer.print("    " + result + " = call " + returnType + " " + typedFunction + "(" + classReg);
    for (LLVMRegister value : values) {
      writer.print(", ");
      writer.print(value);
    }
    writer.println(")");

    return new LLVMRegister(returnType, result);
  }

  /**
   * nodeChoice -> NotExpression() // DONE
   *       | PrimaryExpression()
   */
  @Override
  public LLVMRegister visit(Clause n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "!"
   * clause -> Clause()
   */
  @Override
  public LLVMRegister visit(NotExpression n) throws Exception {
    LLVMRegister bool = n.clause.accept(this).getValue(nameGenerator, writer);
    String res = nameGenerator.generateName();
    writer.println("    " + res + " = icmp eq i1 " + bool.getValue(nameGenerator, writer).getName()
                   + ", false");
    return new LLVMRegister(new Boolean(), res);
  }

  /**
   * nodeChoice -> IntegerLiteral() // DONE
   *       | TrueLiteral()          // DONE
   *       | FalseLiteral()         // DONE
   *       | Identifier()           // WIP
   *       | ThisExpression() // DONE
   *       | ArrayAllocationExpression() // DONE
   *       | AllocationExpression() // DONE
   *       | BracketExpression() // DONE
   */
  @Override
  public LLVMRegister visit(PrimaryExpression n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> <INTEGER_LITERAL>
   */
  @Override
  public LLVMRegister visit(IntegerLiteral n) throws Exception {
    return new LLVMRegister(new Integer(), n.nodeToken.toString());
  }

  /**
   * nodeToken -> "true"
   */
  @Override
  public LLVMRegister visit(TrueLiteral n) throws Exception {
    return new LLVMRegister(new Boolean(), "true");
  }

  /**
   * nodeToken -> "false"
   */
  @Override
  public LLVMRegister visit(FalseLiteral n) throws Exception {
    return new LLVMRegister(new Boolean(), "false");
  }

  /**
   * nodeChoice -> BooleanArrayAllocationExpression() // DONE
   *       | IntegerArrayAllocationExpression() // DONE
   */
  @Override
  public LLVMRegister visit(ArrayAllocationExpression n) throws Exception {
    return n.nodeChoice.accept(this);
  }

  /**
   * nodeToken -> "new"
   * nodeToken1 -> "boolean"
   * nodeToken2 -> "["
   * expression -> Expression()
   * nodeToken3 -> "]"
   */
  @Override
  public LLVMRegister visit(BooleanArrayAllocationExpression n) throws Exception {
    LLVMRegister len = n.expression.accept(this).getValue(nameGenerator, writer);

    String ltz = nameGenerator.generateName();
    writer.println("    " + ltz + " = icmp slt i32 " + len.getName() + ", 0 ; test if size is < 0");

    String negLabel = nameGenerator.generateName();
    String zpLabel = nameGenerator.generateName();
    writer.println("    br i1 " + ltz + ", label " + negLabel + ", label " + zpLabel);
    writer.println(negLabel.substring(1) + ":");
    writer.println("    call void @throw_oob()");
    writer.println("    unreachable");
    writer.println(zpLabel.substring(1) + ":");

    String allocSize = nameGenerator.generateName();
    writer.println("    " + allocSize + " = add " + len + ", 4 ; size of allocation");
    String ptr = nameGenerator.generateName();
    writer.println("    " + ptr + " = call i8* @calloc(i32 1, i32 " + allocSize + ")");

    String array = nameGenerator.generateName();
    writer.println("    " + array + " = bitcast i8* " + ptr + " to %\"i1[]\"*");

    String lenPtr = nameGenerator.generateName();
    writer.println("    " + lenPtr + " = getelementptr %\"i1[]\", %\"i1[]\"* " + array
                   + ", i32 0, i32 0 ; get pointer to len");
    writer.println("    store " + len + ", i32* " + lenPtr + " ; store array length");

    return new LLVMRegister(new Pointer(new Array(new Boolean())), array);
  }

  /**
   * nodeToken -> "new"
   * nodeToken1 -> "int"
   * nodeToken2 -> "["
   * expression -> Expression()
   * nodeToken3 -> "]"
   */
  @Override
  public LLVMRegister visit(IntegerArrayAllocationExpression n) throws Exception {
    LLVMRegister len = n.expression.accept(this).getValue(nameGenerator, writer);

    String ltz = nameGenerator.generateName();
    writer.println("    " + ltz + " = icmp slt i32 " + len.getName() + ", 0 ; test if size is < 0");

    String negLabel = nameGenerator.generateName();
    String zpLabel = nameGenerator.generateName();
    writer.println("    br i1 " + ltz + ", label " + negLabel + ", label " + zpLabel);
    writer.println(negLabel.substring(1) + ":");
    writer.println("    call void @throw_oob()");
    writer.println("    unreachable");
    writer.println(zpLabel.substring(1) + ":");

    String arraySize = nameGenerator.generateName();
    writer.println(
        "    " + arraySize + " = mul " + len + ", 4 ; size of array = len * sizeof(i32)");
    String allocSize = nameGenerator.generateName();
    writer.println("    " + allocSize + " = add i32 " + arraySize + ", 4 ; size of allocation");
    String ptr = nameGenerator.generateName();
    writer.println("    " + ptr + " = call i8* @calloc(i32 1, i32 " + allocSize + ")");

    String array = nameGenerator.generateName();
    writer.println("    " + array + " = bitcast i8* " + ptr + " to %\"i32[]\"*");

    String lenPtr = nameGenerator.generateName();
    writer.println("    " + lenPtr + " = getelementptr %\"i32[]\", %\"i32[]\"* " + array
                   + ", i32 0, i32 0 ; get pointer to len");
    writer.println("    store " + len + ", i32* " + lenPtr + " ; store array length");

    return new LLVMRegister(new Pointer(new Array(new Integer())), array);
  }

  /**
   * nodeToken -> <IDENTIFIER>
   */
  @Override
  public LLVMRegister visit(Identifier n) throws Exception {
    String name = n.nodeToken.toString();

    if (currClass instanceof UserClassSymbol) {
      InheritableMethod method = (InheritableMethod) currMethod;
      Optional<LocalVariable> local = method.getLocalVariable(name);
      if (local.isPresent()) {
        LocalVariable unwrapped = local.get();
        return new LLVMRegister(new Pointer(LLVMType.fromMinijavaType(unwrapped.getType())),
            "%" + name);
      }

      Optional<Parameter> parameter = method.getParameter(name);
      if (parameter.isPresent()) {
        Parameter unwrapped = parameter.get();
        return new LLVMRegister(new Pointer(LLVMType.fromMinijavaType(unwrapped.getType())),
            "%" + name);
      }

      Optional<Field> field = ((UserClassSymbol) currClass).getField(name);
      if (field.isPresent()) {
        Field unwrapped = field.get();
        LLVMType fieldType = LLVMType.fromMinijavaType(unwrapped.getType());

        String fieldPtr = nameGenerator.generateName();
        writer.println(
            "    " + fieldPtr + " = getelementptr i8, i8* %this, i32 " + (unwrapped.getOffset()
                                                                          + 8));
        String typedFieldPtr = nameGenerator.generateName();
        writer.println(
            "    " + typedFieldPtr + " = bitcast i8* " + fieldPtr + " to " + fieldType + "*");

        return new LLVMRegister(new Pointer(fieldType), typedFieldPtr);
      }

      throw new UnsupportedOperationException();
    } else {
      MainMethod method = (MainMethod) currMethod;
      Optional<LocalVariable> local = method.getLocalVariable(name);
      if (local.isPresent()) {
        LocalVariable unwrapped = local.get();
        return new LLVMRegister(new Pointer(LLVMType.fromMinijavaType(unwrapped.getType())),
            "%" + name);
      }
      throw new UnsupportedOperationException();
    }
  }

  /**
   * nodeToken -> "this"
   */
  @Override
  public LLVMRegister visit(ThisExpression n) throws Exception {
    return new LLVMRegister(new Class(currClass.getName()), "%this");
  }

  /**
   * nodeToken -> "new"
   * identifier -> Identifier()
   * nodeToken1 -> "("
   * nodeToken2 -> ")"
   */
  @Override
  public LLVMRegister visit(AllocationExpression n) throws Exception {
    UserClassSymbol cl = symbolTable.getClass(n.identifier.nodeToken.toString());
    String alloc = nameGenerator.generateName();
    writer.println("    " + alloc + " = call i8* @calloc(i32 1, i32 " + cl.getSizeInBytes() + ")");
    String classPtr = nameGenerator.generateName();
    writer.println("    " + classPtr + " = bitcast i8* " + alloc + " to i8***");

    String vTable = nameGenerator.generateName();
    int numOfMethods = cl.getMethods().size();
    writer.println(
        "    " + vTable + " = getelementptr [" + numOfMethods + " x i8*], [" + numOfMethods
        + " x i8*]* @." + cl.getName() + "_vtable, i32 0, i32 0");
    writer.println("    store i8** " + vTable + ", i8*** " + classPtr);
    return new LLVMRegister(new Class(cl.getName()), alloc);
  }

  /**
   * nodeToken -> "("
   * expression -> Expression()
   * nodeToken1 -> ")"
   */
  @Override
  public LLVMRegister visit(BracketExpression n) throws Exception {
    return n.expression.accept(this);
  }
}
