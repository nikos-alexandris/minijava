declare i8* @calloc(i32, i32)
declare i32 @printf(i8*, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"
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

@.LS_vtable = global [4 x i8*] [
    i8* bitcast (i32 (i8*, i32)* @LS.Start to i8*), 
    i8* bitcast (i32 (i8*)* @LS.Print to i8*), 
    i8* bitcast (i32 (i8*, i32)* @LS.Search to i8*), 
    i8* bitcast (i32 (i8*, i32)* @LS.Init to i8*)
]
define i32 @main() {
    %_0 = call i8* @calloc(i32 1, i32 20)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [4 x i8*], [4 x i8*]* @.LS_vtable, i32 0, i32 0
    store i8** %_2, i8*** %_1
    ; %_0.Start : 0
    %_3 = bitcast i8* %_0 to i8***
    %_4 = load i8**, i8*** %_3
    %_5 = getelementptr i8*, i8** %_4, i32 0
    %_6 = load i8*, i8** %_5
    %_7 = bitcast i8* %_6 to i32 (i8*, i32)*
    %_8 = call i32 %_7(i8* %_0, i32 10)
    call void @print_int(i32 %_8) 
    ret i32 0
}

define i32 @LS.Start(i8* %this, i32 %.sz) {
    %sz = alloca i32
    store i32 %.sz, i32* %sz ; add the parameter to the stack

    %aux01 = alloca i32
    %aux02 = alloca i32
    ; %this.Init : 3
    %_0 = bitcast i8* %this to i8***
    %_1 = load i8**, i8*** %_0
    %_2 = getelementptr i8*, i8** %_1, i32 3
    %_3 = load i8*, i8** %_2
    %_4 = bitcast i8* %_3 to i32 (i8*, i32)*
    %_5 = load i32, i32* %sz
    %_6 = call i32 %_4(i8* %this, i32 %_5)
    store i32 %_6, i32* %aux01
    ; %this.Print : 1
    %_7 = bitcast i8* %this to i8***
    %_8 = load i8**, i8*** %_7
    %_9 = getelementptr i8*, i8** %_8, i32 1
    %_10 = load i8*, i8** %_9
    %_11 = bitcast i8* %_10 to i32 (i8*)*
    %_12 = call i32 %_11(i8* %this)
    store i32 %_12, i32* %aux02
    call void @print_int(i32 9999) 
    ; %this.Search : 2
    %_13 = bitcast i8* %this to i8***
    %_14 = load i8**, i8*** %_13
    %_15 = getelementptr i8*, i8** %_14, i32 2
    %_16 = load i8*, i8** %_15
    %_17 = bitcast i8* %_16 to i32 (i8*, i32)*
    %_18 = call i32 %_17(i8* %this, i32 8)
    call void @print_int(i32 %_18) 
    ; %this.Search : 2
    %_19 = bitcast i8* %this to i8***
    %_20 = load i8**, i8*** %_19
    %_21 = getelementptr i8*, i8** %_20, i32 2
    %_22 = load i8*, i8** %_21
    %_23 = bitcast i8* %_22 to i32 (i8*, i32)*
    %_24 = call i32 %_23(i8* %this, i32 12)
    call void @print_int(i32 %_24) 
    ; %this.Search : 2
    %_25 = bitcast i8* %this to i8***
    %_26 = load i8**, i8*** %_25
    %_27 = getelementptr i8*, i8** %_26, i32 2
    %_28 = load i8*, i8** %_27
    %_29 = bitcast i8* %_28 to i32 (i8*, i32)*
    %_30 = call i32 %_29(i8* %this, i32 17)
    call void @print_int(i32 %_30) 
    ; %this.Search : 2
    %_31 = bitcast i8* %this to i8***
    %_32 = load i8**, i8*** %_31
    %_33 = getelementptr i8*, i8** %_32, i32 2
    %_34 = load i8*, i8** %_33
    %_35 = bitcast i8* %_34 to i32 (i8*, i32)*
    %_36 = call i32 %_35(i8* %this, i32 50)
    call void @print_int(i32 %_36) 
    ret i32 55
}
define i32 @LS.Print(i8* %this) {
    %j = alloca i32
    store i32 1, i32* %j
    br label %_0
_0:
    %_3 = load i32, i32* %j
    %_4 = getelementptr i8, i8* %this, i32 16
    %_5 = bitcast i8* %_4 to i32*
    %_6 = load i32, i32* %_5
    %_7 = icmp slt i32 %_3, %_6
    br i1 %_7, label %_1, label %_2
_1:
    %_8 = getelementptr i8, i8* %this, i32 8
    %_9 = bitcast i8* %_8 to %"i32[]"**
    %_10 = load %"i32[]"*, %"i32[]"** %_9
    %_11 = load i32, i32* %j
    %_12 = icmp slt i32 %_11, 0 ; test if index is < 0
    br i1 %_12, label %_13, label %_14
_13:
    call void @throw_oob()
    unreachable
_14:
    %_15 = getelementptr %"i32[]", %"i32[]"* %_10, i32 0, i32 0 ; get pointer to len
    %_16 = load i32, i32* %_15 ; load len
    %_19 = icmp ult i32 %_11, %_16 ; test if index is < len
    br i1 %_19, label %_18, label %_17
_17:
    call void @throw_oob()
    unreachable
_18:
    %_20 = getelementptr %"i32[]", %"i32[]"* %_10, i32 0, i32 1 ; get pointer to array
    %_21  = getelementptr [0 x i32], [0 x i32]* %_20, i32 0, i32 %_11 ; get pointer to value
    %_22 = load i32, i32* %_21 ; load result
    call void @print_int(i32 %_22) 
    %_23 = load i32, i32* %j
    %_24 = add i32 %_23, 1
    store i32 %_24, i32* %j
    br label %_0
_2:
    ret i32 0
}
define i32 @LS.Search(i8* %this, i32 %.num) {
    %num = alloca i32
    store i32 %.num, i32* %num ; add the parameter to the stack

    %j = alloca i32
    %ls01 = alloca i1
    %ifound = alloca i32
    %aux01 = alloca i32
    %aux02 = alloca i32
    %nt = alloca i32
    store i32 1, i32* %j
    store i1 false, i1* %ls01
    store i32 0, i32* %ifound
    br label %_0
_0:
    %_3 = load i32, i32* %j
    %_4 = getelementptr i8, i8* %this, i32 16
    %_5 = bitcast i8* %_4 to i32*
    %_6 = load i32, i32* %_5
    %_7 = icmp slt i32 %_3, %_6
    br i1 %_7, label %_1, label %_2
_1:
    %_8 = getelementptr i8, i8* %this, i32 8
    %_9 = bitcast i8* %_8 to %"i32[]"**
    %_10 = load %"i32[]"*, %"i32[]"** %_9
    %_11 = load i32, i32* %j
    %_12 = icmp slt i32 %_11, 0 ; test if index is < 0
    br i1 %_12, label %_13, label %_14
_13:
    call void @throw_oob()
    unreachable
_14:
    %_15 = getelementptr %"i32[]", %"i32[]"* %_10, i32 0, i32 0 ; get pointer to len
    %_16 = load i32, i32* %_15 ; load len
    %_19 = icmp ult i32 %_11, %_16 ; test if index is < len
    br i1 %_19, label %_18, label %_17
_17:
    call void @throw_oob()
    unreachable
_18:
    %_20 = getelementptr %"i32[]", %"i32[]"* %_10, i32 0, i32 1 ; get pointer to array
    %_21  = getelementptr [0 x i32], [0 x i32]* %_20, i32 0, i32 %_11 ; get pointer to value
    %_22 = load i32, i32* %_21 ; load result
    store i32 %_22, i32* %aux01
    %_23 = load i32, i32* %num
    %_24 = add i32 %_23, 1
    store i32 %_24, i32* %aux02
    %_25 = load i32, i32* %aux01
    %_26 = load i32, i32* %num
    %_27 = icmp slt i32 %_25, %_26
    br i1 %_27, label %_28, label %_29
_28:
    store i32 0, i32* %nt
    br label %_30
_29:
    %_31 = load i32, i32* %aux01
    %_32 = load i32, i32* %aux02
    %_33 = icmp slt i32 %_31, %_32
    %_34 = icmp eq i1 %_33, false
    br i1 %_34, label %_35, label %_36
_35:
    store i32 0, i32* %nt
    br label %_37
_36:
    store i1 true, i1* %ls01
    store i32 1, i32* %ifound
    %_38 = getelementptr i8, i8* %this, i32 16
    %_39 = bitcast i8* %_38 to i32*
    %_40 = load i32, i32* %_39
    store i32 %_40, i32* %j
    br label %_37
_37:
    br label %_30
_30:
    %_41 = load i32, i32* %j
    %_42 = add i32 %_41, 1
    store i32 %_42, i32* %j
    br label %_0
_2:
    %_43 = load i32, i32* %ifound
    ret i32 %_43
}
define i32 @LS.Init(i8* %this, i32 %.sz) {
    %sz = alloca i32
    store i32 %.sz, i32* %sz ; add the parameter to the stack

    %j = alloca i32
    %k = alloca i32
    %aux01 = alloca i32
    %aux02 = alloca i32
    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %sz
    store i32 %_2, i32* %_1
    %_3 = getelementptr i8, i8* %this, i32 8
    %_4 = bitcast i8* %_3 to %"i32[]"**
    %_5 = load i32, i32* %sz
    %_6 = icmp slt i32 %_5, 0 ; test if size is < 0
    br i1 %_6, label %_7, label %_8
_7:
    call void @throw_oob()
    unreachable
_8:
    %_9 = mul i32 %_5, 4 ; size of array = len * sizeof(i32)
    %_10 = add i32 %_9, 4 ; size of allocation
    %_11 = call i8* @calloc(i32 1, i32 %_10)
    %_12 = bitcast i8* %_11 to %"i32[]"*
    %_13 = getelementptr %"i32[]", %"i32[]"* %_12, i32 0, i32 0 ; get pointer to len
    store i32 %_5, i32* %_13 ; store array length
    store %"i32[]"* %_12, %"i32[]"** %_4
    store i32 1, i32* %j
    %_14 = getelementptr i8, i8* %this, i32 16
    %_15 = bitcast i8* %_14 to i32*
    %_16 = load i32, i32* %_15
    %_17 = add i32 %_16, 1
    store i32 %_17, i32* %k
    br label %_18
_18:
    %_21 = load i32, i32* %j
    %_22 = getelementptr i8, i8* %this, i32 16
    %_23 = bitcast i8* %_22 to i32*
    %_24 = load i32, i32* %_23
    %_25 = icmp slt i32 %_21, %_24
    br i1 %_25, label %_19, label %_20
_19:
    %_26 = load i32, i32* %j
    %_27 = mul i32 2, %_26
    store i32 %_27, i32* %aux01
    %_28 = load i32, i32* %k
    %_29 = sub i32 %_28, 3
    store i32 %_29, i32* %aux02
    %_30 = getelementptr i8, i8* %this, i32 8
    %_31 = bitcast i8* %_30 to %"i32[]"**
    %_32 = load %"i32[]"*, %"i32[]"** %_31
    %_33 = load i32, i32* %j
    %_34 = icmp slt i32 %_33, 0 ; test if index is < 0
    br i1 %_34, label %_35, label %_36
_35:
    call void @throw_oob()
    unreachable
_36:
    %_37 = load i32, i32* %aux01
    %_38 = load i32, i32* %aux02
    %_39 = add i32 %_37, %_38
    %_40 = getelementptr %"i32[]", %"i32[]"* %_32, i32 0, i32 0 ; get pointer to len
    %_41 = load i32, i32* %_40 ; load array length
    %_44 = icmp ult i32 %_33, %_41 ; test if index is < len
    br i1 %_44, label %_43, label %_42
_42:
    call void @throw_oob()
    unreachable
_43:
    %_45 = getelementptr %"i32[]", %"i32[]"* %_32, i32 0, i32 1 ; get pointer to array
    %_46  = getelementptr [0 x i32], [0 x i32]* %_45, i32 0, i32 %_33 ; get pointer to value
    store i32 %_39, i32* %_46
    %_47 = load i32, i32* %j
    %_48 = add i32 %_47, 1
    store i32 %_48, i32* %j
    %_49 = load i32, i32* %k
    %_50 = sub i32 %_49, 1
    store i32 %_50, i32* %k
    br label %_18
_20:
    ret i32 0
}
