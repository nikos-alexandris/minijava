package minijava.codegen.llvm;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import minijava._auto.syntaxtree.Goal;
import minijava.codegen.llvm.generators.VTableGenerator;
import minijava.codegen.llvm.visitors.CodegenVisitor;
import minijava.symboltable.SymbolTable;

public class CodeGenerator {

  private final SymbolTable symbolTable;
  private final PrintWriter writer;

  public CodeGenerator(SymbolTable symbolTable, File file) throws FileNotFoundException {
    this.symbolTable = symbolTable;
    this.writer = new PrintWriter(new FileOutputStream(file), true);
  }

  public void run(Goal ast) throws Exception {
    generateBoilerPlate();
    new VTableGenerator(symbolTable, writer).generate();
    new CodegenVisitor(symbolTable, writer).visit(ast);
    this.writer.close();
  }

  private void generateBoilerPlate() {
    writer.println("""
        declare i8* @calloc(i32, i32)
        declare i32 @printf(i8*, ...)
        declare void @exit(i32)
                    
        @_cint = constant [4 x i8] c"%d\\0a\\00"
        @_cOOB = constant [15 x i8] c"Out of bounds\\0a\\00"
        define void @print_int(i32 %i) {
            %_str = bitcast [4 x i8]* @_cint to i8*
            call i32 (i8*, ...) @printf(i8* %_str, i32 %i)
            ret void
        }
                
        define void @print_bool(i1 %b) {
            %_str = bitcast [4 x i8]* @_cint to i8*
            call i32 (i8*, ...) @printf(i8* %_str, i1 %b)
            ret void
        }
                    
        define void @throw_oob() {
            %_str = bitcast [15 x i8]* @_cOOB to i8*
            call i32 (i8*, ...) @printf(i8* %_str)
            call void @exit(i32 1)
            ret void
        }
                
        ; End of boilerplate
                
        %"i32[]" = type { i32, [0 x i32] }
        %"i1[]" = type { i32, [0 x i1] }
        """);
  }
}
