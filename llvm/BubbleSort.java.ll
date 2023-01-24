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

@.BBS_vtable = global [4 x i8*] [
    i8* bitcast (i32 (i8*, i32)* @BBS.Start to i8*), 
    i8* bitcast (i32 (i8*)* @BBS.Sort to i8*), 
    i8* bitcast (i32 (i8*)* @BBS.Print to i8*), 
    i8* bitcast (i32 (i8*, i32)* @BBS.Init to i8*)
]
define i32 @main() {
    %_0 = call i8* @calloc(i32 1, i32 20)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [4 x i8*], [4 x i8*]* @.BBS_vtable, i32 0, i32 0
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

define i32 @BBS.Start(i8* %this, i32 %.sz) {
    %sz = alloca i32
    store i32 %.sz, i32* %sz ; add the parameter to the stack

    %aux01 = alloca i32
    ; %this.Init : 3
    %_0 = bitcast i8* %this to i8***
    %_1 = load i8**, i8*** %_0
    %_2 = getelementptr i8*, i8** %_1, i32 3
    %_3 = load i8*, i8** %_2
    %_4 = bitcast i8* %_3 to i32 (i8*, i32)*
    %_5 = load i32, i32* %sz
    %_6 = call i32 %_4(i8* %this, i32 %_5)
    store i32 %_6, i32* %aux01
    ; %this.Print : 2
    %_7 = bitcast i8* %this to i8***
    %_8 = load i8**, i8*** %_7
    %_9 = getelementptr i8*, i8** %_8, i32 2
    %_10 = load i8*, i8** %_9
    %_11 = bitcast i8* %_10 to i32 (i8*)*
    %_12 = call i32 %_11(i8* %this)
    store i32 %_12, i32* %aux01
    call void @print_int(i32 99999) 
    ; %this.Sort : 1
    %_13 = bitcast i8* %this to i8***
    %_14 = load i8**, i8*** %_13
    %_15 = getelementptr i8*, i8** %_14, i32 1
    %_16 = load i8*, i8** %_15
    %_17 = bitcast i8* %_16 to i32 (i8*)*
    %_18 = call i32 %_17(i8* %this)
    store i32 %_18, i32* %aux01
    ; %this.Print : 2
    %_19 = bitcast i8* %this to i8***
    %_20 = load i8**, i8*** %_19
    %_21 = getelementptr i8*, i8** %_20, i32 2
    %_22 = load i8*, i8** %_21
    %_23 = bitcast i8* %_22 to i32 (i8*)*
    %_24 = call i32 %_23(i8* %this)
    store i32 %_24, i32* %aux01
    ret i32 0
}
define i32 @BBS.Sort(i8* %this) {
    %nt = alloca i32
    %i = alloca i32
    %aux02 = alloca i32
    %aux04 = alloca i32
    %aux05 = alloca i32
    %aux06 = alloca i32
    %aux07 = alloca i32
    %j = alloca i32
    %t = alloca i32
    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %_1
    %_3 = sub i32 %_2, 1
    store i32 %_3, i32* %i
    %_4 = sub i32 0, 1
    store i32 %_4, i32* %aux02
    br label %_5
_5:
    %_8 = load i32, i32* %aux02
    %_9 = load i32, i32* %i
    %_10 = icmp slt i32 %_8, %_9
    br i1 %_10, label %_6, label %_7
_6:
    store i32 1, i32* %j
    br label %_11
_11:
    %_14 = load i32, i32* %j
    %_15 = load i32, i32* %i
    %_16 = add i32 %_15, 1
    %_17 = icmp slt i32 %_14, %_16
    br i1 %_17, label %_12, label %_13
_12:
    %_18 = load i32, i32* %j
    %_19 = sub i32 %_18, 1
    store i32 %_19, i32* %aux07
    %_20 = getelementptr i8, i8* %this, i32 8
    %_21 = bitcast i8* %_20 to %"i32[]"**
    %_22 = load %"i32[]"*, %"i32[]"** %_21
    %_23 = load i32, i32* %aux07
    %_24 = icmp slt i32 %_23, 0 ; test if index is < 0
    br i1 %_24, label %_25, label %_26
_25:
    call void @throw_oob()
    unreachable
_26:
    %_27 = getelementptr %"i32[]", %"i32[]"* %_22, i32 0, i32 0 ; get pointer to len
    %_28 = load i32, i32* %_27 ; load len
    %_31 = icmp ult i32 %_23, %_28 ; test if index is < len
    br i1 %_31, label %_30, label %_29
_29:
    call void @throw_oob()
    unreachable
_30:
    %_32 = getelementptr %"i32[]", %"i32[]"* %_22, i32 0, i32 1 ; get pointer to array
    %_33  = getelementptr [0 x i32], [0 x i32]* %_32, i32 0, i32 %_23 ; get pointer to value
    %_34 = load i32, i32* %_33 ; load result
    store i32 %_34, i32* %aux04
    %_35 = getelementptr i8, i8* %this, i32 8
    %_36 = bitcast i8* %_35 to %"i32[]"**
    %_37 = load %"i32[]"*, %"i32[]"** %_36
    %_38 = load i32, i32* %j
    %_39 = icmp slt i32 %_38, 0 ; test if index is < 0
    br i1 %_39, label %_40, label %_41
_40:
    call void @throw_oob()
    unreachable
_41:
    %_42 = getelementptr %"i32[]", %"i32[]"* %_37, i32 0, i32 0 ; get pointer to len
    %_43 = load i32, i32* %_42 ; load len
    %_46 = icmp ult i32 %_38, %_43 ; test if index is < len
    br i1 %_46, label %_45, label %_44
_44:
    call void @throw_oob()
    unreachable
_45:
    %_47 = getelementptr %"i32[]", %"i32[]"* %_37, i32 0, i32 1 ; get pointer to array
    %_48  = getelementptr [0 x i32], [0 x i32]* %_47, i32 0, i32 %_38 ; get pointer to value
    %_49 = load i32, i32* %_48 ; load result
    store i32 %_49, i32* %aux05
    %_50 = load i32, i32* %aux05
    %_51 = load i32, i32* %aux04
    %_52 = icmp slt i32 %_50, %_51
    br i1 %_52, label %_53, label %_54
_53:
    %_56 = load i32, i32* %j
    %_57 = sub i32 %_56, 1
    store i32 %_57, i32* %aux06
    %_58 = getelementptr i8, i8* %this, i32 8
    %_59 = bitcast i8* %_58 to %"i32[]"**
    %_60 = load %"i32[]"*, %"i32[]"** %_59
    %_61 = load i32, i32* %aux06
    %_62 = icmp slt i32 %_61, 0 ; test if index is < 0
    br i1 %_62, label %_63, label %_64
_63:
    call void @throw_oob()
    unreachable
_64:
    %_65 = getelementptr %"i32[]", %"i32[]"* %_60, i32 0, i32 0 ; get pointer to len
    %_66 = load i32, i32* %_65 ; load len
    %_69 = icmp ult i32 %_61, %_66 ; test if index is < len
    br i1 %_69, label %_68, label %_67
_67:
    call void @throw_oob()
    unreachable
_68:
    %_70 = getelementptr %"i32[]", %"i32[]"* %_60, i32 0, i32 1 ; get pointer to array
    %_71  = getelementptr [0 x i32], [0 x i32]* %_70, i32 0, i32 %_61 ; get pointer to value
    %_72 = load i32, i32* %_71 ; load result
    store i32 %_72, i32* %t
    %_73 = getelementptr i8, i8* %this, i32 8
    %_74 = bitcast i8* %_73 to %"i32[]"**
    %_75 = load %"i32[]"*, %"i32[]"** %_74
    %_76 = load i32, i32* %aux06
    %_77 = icmp slt i32 %_76, 0 ; test if index is < 0
    br i1 %_77, label %_78, label %_79
_78:
    call void @throw_oob()
    unreachable
_79:
    %_80 = getelementptr i8, i8* %this, i32 8
    %_81 = bitcast i8* %_80 to %"i32[]"**
    %_82 = load %"i32[]"*, %"i32[]"** %_81
    %_83 = load i32, i32* %j
    %_84 = icmp slt i32 %_83, 0 ; test if index is < 0
    br i1 %_84, label %_85, label %_86
_85:
    call void @throw_oob()
    unreachable
_86:
    %_87 = getelementptr %"i32[]", %"i32[]"* %_82, i32 0, i32 0 ; get pointer to len
    %_88 = load i32, i32* %_87 ; load len
    %_91 = icmp ult i32 %_83, %_88 ; test if index is < len
    br i1 %_91, label %_90, label %_89
_89:
    call void @throw_oob()
    unreachable
_90:
    %_92 = getelementptr %"i32[]", %"i32[]"* %_82, i32 0, i32 1 ; get pointer to array
    %_93  = getelementptr [0 x i32], [0 x i32]* %_92, i32 0, i32 %_83 ; get pointer to value
    %_94 = load i32, i32* %_93 ; load result
    %_95 = getelementptr %"i32[]", %"i32[]"* %_75, i32 0, i32 0 ; get pointer to len
    %_96 = load i32, i32* %_95 ; load array length
    %_99 = icmp ult i32 %_76, %_96 ; test if index is < len
    br i1 %_99, label %_98, label %_97
_97:
    call void @throw_oob()
    unreachable
_98:
    %_100 = getelementptr %"i32[]", %"i32[]"* %_75, i32 0, i32 1 ; get pointer to array
    %_101  = getelementptr [0 x i32], [0 x i32]* %_100, i32 0, i32 %_76 ; get pointer to value
    store i32 %_94, i32* %_101
    %_102 = getelementptr i8, i8* %this, i32 8
    %_103 = bitcast i8* %_102 to %"i32[]"**
    %_104 = load %"i32[]"*, %"i32[]"** %_103
    %_105 = load i32, i32* %j
    %_106 = icmp slt i32 %_105, 0 ; test if index is < 0
    br i1 %_106, label %_107, label %_108
_107:
    call void @throw_oob()
    unreachable
_108:
    %_109 = load i32, i32* %t
    %_110 = getelementptr %"i32[]", %"i32[]"* %_104, i32 0, i32 0 ; get pointer to len
    %_111 = load i32, i32* %_110 ; load array length
    %_114 = icmp ult i32 %_105, %_111 ; test if index is < len
    br i1 %_114, label %_113, label %_112
_112:
    call void @throw_oob()
    unreachable
_113:
    %_115 = getelementptr %"i32[]", %"i32[]"* %_104, i32 0, i32 1 ; get pointer to array
    %_116  = getelementptr [0 x i32], [0 x i32]* %_115, i32 0, i32 %_105 ; get pointer to value
    store i32 %_109, i32* %_116
    br label %_55
_54:
    store i32 0, i32* %nt
    br label %_55
_55:
    %_117 = load i32, i32* %j
    %_118 = add i32 %_117, 1
    store i32 %_118, i32* %j
    br label %_11
_13:
    %_119 = load i32, i32* %i
    %_120 = sub i32 %_119, 1
    store i32 %_120, i32* %i
    br label %_5
_7:
    ret i32 0
}
define i32 @BBS.Print(i8* %this) {
    %j = alloca i32
    store i32 0, i32* %j
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
define i32 @BBS.Init(i8* %this, i32 %.sz) {
    %sz = alloca i32
    store i32 %.sz, i32* %sz ; add the parameter to the stack

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
    %_14 = getelementptr i8, i8* %this, i32 8
    %_15 = bitcast i8* %_14 to %"i32[]"**
    %_16 = load %"i32[]"*, %"i32[]"** %_15
    %_17 = icmp slt i32 0, 0 ; test if index is < 0
    br i1 %_17, label %_18, label %_19
_18:
    call void @throw_oob()
    unreachable
_19:
    %_20 = getelementptr %"i32[]", %"i32[]"* %_16, i32 0, i32 0 ; get pointer to len
    %_21 = load i32, i32* %_20 ; load array length
    %_24 = icmp ult i32 0, %_21 ; test if index is < len
    br i1 %_24, label %_23, label %_22
_22:
    call void @throw_oob()
    unreachable
_23:
    %_25 = getelementptr %"i32[]", %"i32[]"* %_16, i32 0, i32 1 ; get pointer to array
    %_26  = getelementptr [0 x i32], [0 x i32]* %_25, i32 0, i32 0 ; get pointer to value
    store i32 20, i32* %_26
    %_27 = getelementptr i8, i8* %this, i32 8
    %_28 = bitcast i8* %_27 to %"i32[]"**
    %_29 = load %"i32[]"*, %"i32[]"** %_28
    %_30 = icmp slt i32 1, 0 ; test if index is < 0
    br i1 %_30, label %_31, label %_32
_31:
    call void @throw_oob()
    unreachable
_32:
    %_33 = getelementptr %"i32[]", %"i32[]"* %_29, i32 0, i32 0 ; get pointer to len
    %_34 = load i32, i32* %_33 ; load array length
    %_37 = icmp ult i32 1, %_34 ; test if index is < len
    br i1 %_37, label %_36, label %_35
_35:
    call void @throw_oob()
    unreachable
_36:
    %_38 = getelementptr %"i32[]", %"i32[]"* %_29, i32 0, i32 1 ; get pointer to array
    %_39  = getelementptr [0 x i32], [0 x i32]* %_38, i32 0, i32 1 ; get pointer to value
    store i32 7, i32* %_39
    %_40 = getelementptr i8, i8* %this, i32 8
    %_41 = bitcast i8* %_40 to %"i32[]"**
    %_42 = load %"i32[]"*, %"i32[]"** %_41
    %_43 = icmp slt i32 2, 0 ; test if index is < 0
    br i1 %_43, label %_44, label %_45
_44:
    call void @throw_oob()
    unreachable
_45:
    %_46 = getelementptr %"i32[]", %"i32[]"* %_42, i32 0, i32 0 ; get pointer to len
    %_47 = load i32, i32* %_46 ; load array length
    %_50 = icmp ult i32 2, %_47 ; test if index is < len
    br i1 %_50, label %_49, label %_48
_48:
    call void @throw_oob()
    unreachable
_49:
    %_51 = getelementptr %"i32[]", %"i32[]"* %_42, i32 0, i32 1 ; get pointer to array
    %_52  = getelementptr [0 x i32], [0 x i32]* %_51, i32 0, i32 2 ; get pointer to value
    store i32 12, i32* %_52
    %_53 = getelementptr i8, i8* %this, i32 8
    %_54 = bitcast i8* %_53 to %"i32[]"**
    %_55 = load %"i32[]"*, %"i32[]"** %_54
    %_56 = icmp slt i32 3, 0 ; test if index is < 0
    br i1 %_56, label %_57, label %_58
_57:
    call void @throw_oob()
    unreachable
_58:
    %_59 = getelementptr %"i32[]", %"i32[]"* %_55, i32 0, i32 0 ; get pointer to len
    %_60 = load i32, i32* %_59 ; load array length
    %_63 = icmp ult i32 3, %_60 ; test if index is < len
    br i1 %_63, label %_62, label %_61
_61:
    call void @throw_oob()
    unreachable
_62:
    %_64 = getelementptr %"i32[]", %"i32[]"* %_55, i32 0, i32 1 ; get pointer to array
    %_65  = getelementptr [0 x i32], [0 x i32]* %_64, i32 0, i32 3 ; get pointer to value
    store i32 18, i32* %_65
    %_66 = getelementptr i8, i8* %this, i32 8
    %_67 = bitcast i8* %_66 to %"i32[]"**
    %_68 = load %"i32[]"*, %"i32[]"** %_67
    %_69 = icmp slt i32 4, 0 ; test if index is < 0
    br i1 %_69, label %_70, label %_71
_70:
    call void @throw_oob()
    unreachable
_71:
    %_72 = getelementptr %"i32[]", %"i32[]"* %_68, i32 0, i32 0 ; get pointer to len
    %_73 = load i32, i32* %_72 ; load array length
    %_76 = icmp ult i32 4, %_73 ; test if index is < len
    br i1 %_76, label %_75, label %_74
_74:
    call void @throw_oob()
    unreachable
_75:
    %_77 = getelementptr %"i32[]", %"i32[]"* %_68, i32 0, i32 1 ; get pointer to array
    %_78  = getelementptr [0 x i32], [0 x i32]* %_77, i32 0, i32 4 ; get pointer to value
    store i32 2, i32* %_78
    %_79 = getelementptr i8, i8* %this, i32 8
    %_80 = bitcast i8* %_79 to %"i32[]"**
    %_81 = load %"i32[]"*, %"i32[]"** %_80
    %_82 = icmp slt i32 5, 0 ; test if index is < 0
    br i1 %_82, label %_83, label %_84
_83:
    call void @throw_oob()
    unreachable
_84:
    %_85 = getelementptr %"i32[]", %"i32[]"* %_81, i32 0, i32 0 ; get pointer to len
    %_86 = load i32, i32* %_85 ; load array length
    %_89 = icmp ult i32 5, %_86 ; test if index is < len
    br i1 %_89, label %_88, label %_87
_87:
    call void @throw_oob()
    unreachable
_88:
    %_90 = getelementptr %"i32[]", %"i32[]"* %_81, i32 0, i32 1 ; get pointer to array
    %_91  = getelementptr [0 x i32], [0 x i32]* %_90, i32 0, i32 5 ; get pointer to value
    store i32 11, i32* %_91
    %_92 = getelementptr i8, i8* %this, i32 8
    %_93 = bitcast i8* %_92 to %"i32[]"**
    %_94 = load %"i32[]"*, %"i32[]"** %_93
    %_95 = icmp slt i32 6, 0 ; test if index is < 0
    br i1 %_95, label %_96, label %_97
_96:
    call void @throw_oob()
    unreachable
_97:
    %_98 = getelementptr %"i32[]", %"i32[]"* %_94, i32 0, i32 0 ; get pointer to len
    %_99 = load i32, i32* %_98 ; load array length
    %_102 = icmp ult i32 6, %_99 ; test if index is < len
    br i1 %_102, label %_101, label %_100
_100:
    call void @throw_oob()
    unreachable
_101:
    %_103 = getelementptr %"i32[]", %"i32[]"* %_94, i32 0, i32 1 ; get pointer to array
    %_104  = getelementptr [0 x i32], [0 x i32]* %_103, i32 0, i32 6 ; get pointer to value
    store i32 6, i32* %_104
    %_105 = getelementptr i8, i8* %this, i32 8
    %_106 = bitcast i8* %_105 to %"i32[]"**
    %_107 = load %"i32[]"*, %"i32[]"** %_106
    %_108 = icmp slt i32 7, 0 ; test if index is < 0
    br i1 %_108, label %_109, label %_110
_109:
    call void @throw_oob()
    unreachable
_110:
    %_111 = getelementptr %"i32[]", %"i32[]"* %_107, i32 0, i32 0 ; get pointer to len
    %_112 = load i32, i32* %_111 ; load array length
    %_115 = icmp ult i32 7, %_112 ; test if index is < len
    br i1 %_115, label %_114, label %_113
_113:
    call void @throw_oob()
    unreachable
_114:
    %_116 = getelementptr %"i32[]", %"i32[]"* %_107, i32 0, i32 1 ; get pointer to array
    %_117  = getelementptr [0 x i32], [0 x i32]* %_116, i32 0, i32 7 ; get pointer to value
    store i32 9, i32* %_117
    %_118 = getelementptr i8, i8* %this, i32 8
    %_119 = bitcast i8* %_118 to %"i32[]"**
    %_120 = load %"i32[]"*, %"i32[]"** %_119
    %_121 = icmp slt i32 8, 0 ; test if index is < 0
    br i1 %_121, label %_122, label %_123
_122:
    call void @throw_oob()
    unreachable
_123:
    %_124 = getelementptr %"i32[]", %"i32[]"* %_120, i32 0, i32 0 ; get pointer to len
    %_125 = load i32, i32* %_124 ; load array length
    %_128 = icmp ult i32 8, %_125 ; test if index is < len
    br i1 %_128, label %_127, label %_126
_126:
    call void @throw_oob()
    unreachable
_127:
    %_129 = getelementptr %"i32[]", %"i32[]"* %_120, i32 0, i32 1 ; get pointer to array
    %_130  = getelementptr [0 x i32], [0 x i32]* %_129, i32 0, i32 8 ; get pointer to value
    store i32 19, i32* %_130
    %_131 = getelementptr i8, i8* %this, i32 8
    %_132 = bitcast i8* %_131 to %"i32[]"**
    %_133 = load %"i32[]"*, %"i32[]"** %_132
    %_134 = icmp slt i32 9, 0 ; test if index is < 0
    br i1 %_134, label %_135, label %_136
_135:
    call void @throw_oob()
    unreachable
_136:
    %_137 = getelementptr %"i32[]", %"i32[]"* %_133, i32 0, i32 0 ; get pointer to len
    %_138 = load i32, i32* %_137 ; load array length
    %_141 = icmp ult i32 9, %_138 ; test if index is < len
    br i1 %_141, label %_140, label %_139
_139:
    call void @throw_oob()
    unreachable
_140:
    %_142 = getelementptr %"i32[]", %"i32[]"* %_133, i32 0, i32 1 ; get pointer to array
    %_143  = getelementptr [0 x i32], [0 x i32]* %_142, i32 0, i32 9 ; get pointer to value
    store i32 5, i32* %_143
    ret i32 0
}
