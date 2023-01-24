# minijava

This is a Minijava to LLVM compiler, complete with semantic analysis, typechecking, etc.

## Build

To build the project, run

```bash
make
```

## Run

To run the compiler on a file, do

```bash
java -cp bin minijava.Main <your_file>
```

This will generate LLVM IR in the `llvm` directory. To run the generated LLVM IR, do

```bash
lli llvm/<your_file>.ll
```

## Tests

> You need to have ran `make` before running the tests.

To run the tests, run

```bash
make execute INPUT_FILES='`find minijava-examples -maxdepth 1 -type f`'
```

Any file name ending in `error.java` should fail to compile. All other files should compile successfully. The generated LLVM IR is saved in the `llvm` directory.
