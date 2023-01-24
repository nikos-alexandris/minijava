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

@.TV_vtable = global [1 x i8*] [
    i8* bitcast (i32 (i8*)* @TV.Start to i8*)
]
@.Visitor_vtable = global [1 x i8*] [
    i8* bitcast (i32 (i8*, i8*)* @Visitor.visit to i8*)
]
@.Tree_vtable = global [21 x i8*] [
    i8* bitcast (i1 (i8*, i32)* @Tree.Init to i8*), 
    i8* bitcast (i1 (i8*, i8*)* @Tree.SetRight to i8*), 
    i8* bitcast (i1 (i8*, i8*)* @Tree.SetLeft to i8*), 
    i8* bitcast (i8* (i8*)* @Tree.GetRight to i8*), 
    i8* bitcast (i8* (i8*)* @Tree.GetLeft to i8*), 
    i8* bitcast (i32 (i8*)* @Tree.GetKey to i8*), 
    i8* bitcast (i1 (i8*, i32)* @Tree.SetKey to i8*), 
    i8* bitcast (i1 (i8*)* @Tree.GetHas_Right to i8*), 
    i8* bitcast (i1 (i8*)* @Tree.GetHas_Left to i8*), 
    i8* bitcast (i1 (i8*, i1)* @Tree.SetHas_Left to i8*), 
    i8* bitcast (i1 (i8*, i1)* @Tree.SetHas_Right to i8*), 
    i8* bitcast (i1 (i8*, i32, i32)* @Tree.Compare to i8*), 
    i8* bitcast (i1 (i8*, i32)* @Tree.Insert to i8*), 
    i8* bitcast (i1 (i8*, i32)* @Tree.Delete to i8*), 
    i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.Remove to i8*), 
    i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.RemoveRight to i8*), 
    i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.RemoveLeft to i8*), 
    i8* bitcast (i32 (i8*, i32)* @Tree.Search to i8*), 
    i8* bitcast (i1 (i8*)* @Tree.Print to i8*), 
    i8* bitcast (i1 (i8*, i8*)* @Tree.RecPrint to i8*), 
    i8* bitcast (i32 (i8*, i8*)* @Tree.accept to i8*)
]
@.MyVisitor_vtable = global [1 x i8*] [
    i8* bitcast (i32 (i8*, i8*)* @MyVisitor.visit to i8*)
]
define i32 @main() {
    %_0 = call i8* @calloc(i32 1, i32 8)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [1 x i8*], [1 x i8*]* @.TV_vtable, i32 0, i32 0
    store i8** %_2, i8*** %_1
    ; %_0.Start : 0
    %_3 = bitcast i8* %_0 to i8***
    %_4 = load i8**, i8*** %_3
    %_5 = getelementptr i8*, i8** %_4, i32 0
    %_6 = load i8*, i8** %_5
    %_7 = bitcast i8* %_6 to i32 (i8*)*
    %_8 = call i32 %_7(i8* %_0)
    call void @print_int(i32 %_8) 
    ret i32 0
}

define i32 @TV.Start(i8* %this) {
    %root = alloca i8*
    %ntb = alloca i1
    %nti = alloca i32
    %v = alloca i8*
    %_0 = call i8* @calloc(i32 1, i32 38)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [21 x i8*], [21 x i8*]* @.Tree_vtable, i32 0, i32 0
    store i8** %_2, i8*** %_1
    store i8* %_0, i8** %root
    %_3 = load i8*, i8** %root
    ; %_3.Init : 0
    %_4 = bitcast i8* %_3 to i8***
    %_5 = load i8**, i8*** %_4
    %_6 = getelementptr i8*, i8** %_5, i32 0
    %_7 = load i8*, i8** %_6
    %_8 = bitcast i8* %_7 to i1 (i8*, i32)*
    %_9 = call i1 %_8(i8* %_3, i32 16)
    store i1 %_9, i1* %ntb
    %_10 = load i8*, i8** %root
    ; %_10.Print : 18
    %_11 = bitcast i8* %_10 to i8***
    %_12 = load i8**, i8*** %_11
    %_13 = getelementptr i8*, i8** %_12, i32 18
    %_14 = load i8*, i8** %_13
    %_15 = bitcast i8* %_14 to i1 (i8*)*
    %_16 = call i1 %_15(i8* %_10)
    store i1 %_16, i1* %ntb
    call void @print_int(i32 100000000) 
    %_17 = load i8*, i8** %root
    ; %_17.Insert : 12
    %_18 = bitcast i8* %_17 to i8***
    %_19 = load i8**, i8*** %_18
    %_20 = getelementptr i8*, i8** %_19, i32 12
    %_21 = load i8*, i8** %_20
    %_22 = bitcast i8* %_21 to i1 (i8*, i32)*
    %_23 = call i1 %_22(i8* %_17, i32 8)
    store i1 %_23, i1* %ntb
    %_24 = load i8*, i8** %root
    ; %_24.Insert : 12
    %_25 = bitcast i8* %_24 to i8***
    %_26 = load i8**, i8*** %_25
    %_27 = getelementptr i8*, i8** %_26, i32 12
    %_28 = load i8*, i8** %_27
    %_29 = bitcast i8* %_28 to i1 (i8*, i32)*
    %_30 = call i1 %_29(i8* %_24, i32 24)
    store i1 %_30, i1* %ntb
    %_31 = load i8*, i8** %root
    ; %_31.Insert : 12
    %_32 = bitcast i8* %_31 to i8***
    %_33 = load i8**, i8*** %_32
    %_34 = getelementptr i8*, i8** %_33, i32 12
    %_35 = load i8*, i8** %_34
    %_36 = bitcast i8* %_35 to i1 (i8*, i32)*
    %_37 = call i1 %_36(i8* %_31, i32 4)
    store i1 %_37, i1* %ntb
    %_38 = load i8*, i8** %root
    ; %_38.Insert : 12
    %_39 = bitcast i8* %_38 to i8***
    %_40 = load i8**, i8*** %_39
    %_41 = getelementptr i8*, i8** %_40, i32 12
    %_42 = load i8*, i8** %_41
    %_43 = bitcast i8* %_42 to i1 (i8*, i32)*
    %_44 = call i1 %_43(i8* %_38, i32 12)
    store i1 %_44, i1* %ntb
    %_45 = load i8*, i8** %root
    ; %_45.Insert : 12
    %_46 = bitcast i8* %_45 to i8***
    %_47 = load i8**, i8*** %_46
    %_48 = getelementptr i8*, i8** %_47, i32 12
    %_49 = load i8*, i8** %_48
    %_50 = bitcast i8* %_49 to i1 (i8*, i32)*
    %_51 = call i1 %_50(i8* %_45, i32 20)
    store i1 %_51, i1* %ntb
    %_52 = load i8*, i8** %root
    ; %_52.Insert : 12
    %_53 = bitcast i8* %_52 to i8***
    %_54 = load i8**, i8*** %_53
    %_55 = getelementptr i8*, i8** %_54, i32 12
    %_56 = load i8*, i8** %_55
    %_57 = bitcast i8* %_56 to i1 (i8*, i32)*
    %_58 = call i1 %_57(i8* %_52, i32 28)
    store i1 %_58, i1* %ntb
    %_59 = load i8*, i8** %root
    ; %_59.Insert : 12
    %_60 = bitcast i8* %_59 to i8***
    %_61 = load i8**, i8*** %_60
    %_62 = getelementptr i8*, i8** %_61, i32 12
    %_63 = load i8*, i8** %_62
    %_64 = bitcast i8* %_63 to i1 (i8*, i32)*
    %_65 = call i1 %_64(i8* %_59, i32 14)
    store i1 %_65, i1* %ntb
    %_66 = load i8*, i8** %root
    ; %_66.Print : 18
    %_67 = bitcast i8* %_66 to i8***
    %_68 = load i8**, i8*** %_67
    %_69 = getelementptr i8*, i8** %_68, i32 18
    %_70 = load i8*, i8** %_69
    %_71 = bitcast i8* %_70 to i1 (i8*)*
    %_72 = call i1 %_71(i8* %_66)
    store i1 %_72, i1* %ntb
    call void @print_int(i32 100000000) 
    %_73 = call i8* @calloc(i32 1, i32 24)
    %_74 = bitcast i8* %_73 to i8***
    %_75 = getelementptr [1 x i8*], [1 x i8*]* @.MyVisitor_vtable, i32 0, i32 0
    store i8** %_75, i8*** %_74
    store i8* %_73, i8** %v
    call void @print_int(i32 50000000) 
    %_76 = load i8*, i8** %root
    ; %_76.accept : 20
    %_77 = bitcast i8* %_76 to i8***
    %_78 = load i8**, i8*** %_77
    %_79 = getelementptr i8*, i8** %_78, i32 20
    %_80 = load i8*, i8** %_79
    %_81 = bitcast i8* %_80 to i32 (i8*, i8*)*
    %_82 = load i8*, i8** %v
    %_83 = call i32 %_81(i8* %_76, i8* %_82)
    store i32 %_83, i32* %nti
    call void @print_int(i32 100000000) 
    %_84 = load i8*, i8** %root
    ; %_84.Search : 17
    %_85 = bitcast i8* %_84 to i8***
    %_86 = load i8**, i8*** %_85
    %_87 = getelementptr i8*, i8** %_86, i32 17
    %_88 = load i8*, i8** %_87
    %_89 = bitcast i8* %_88 to i32 (i8*, i32)*
    %_90 = call i32 %_89(i8* %_84, i32 24)
    call void @print_int(i32 %_90) 
    %_91 = load i8*, i8** %root
    ; %_91.Search : 17
    %_92 = bitcast i8* %_91 to i8***
    %_93 = load i8**, i8*** %_92
    %_94 = getelementptr i8*, i8** %_93, i32 17
    %_95 = load i8*, i8** %_94
    %_96 = bitcast i8* %_95 to i32 (i8*, i32)*
    %_97 = call i32 %_96(i8* %_91, i32 12)
    call void @print_int(i32 %_97) 
    %_98 = load i8*, i8** %root
    ; %_98.Search : 17
    %_99 = bitcast i8* %_98 to i8***
    %_100 = load i8**, i8*** %_99
    %_101 = getelementptr i8*, i8** %_100, i32 17
    %_102 = load i8*, i8** %_101
    %_103 = bitcast i8* %_102 to i32 (i8*, i32)*
    %_104 = call i32 %_103(i8* %_98, i32 16)
    call void @print_int(i32 %_104) 
    %_105 = load i8*, i8** %root
    ; %_105.Search : 17
    %_106 = bitcast i8* %_105 to i8***
    %_107 = load i8**, i8*** %_106
    %_108 = getelementptr i8*, i8** %_107, i32 17
    %_109 = load i8*, i8** %_108
    %_110 = bitcast i8* %_109 to i32 (i8*, i32)*
    %_111 = call i32 %_110(i8* %_105, i32 50)
    call void @print_int(i32 %_111) 
    %_112 = load i8*, i8** %root
    ; %_112.Search : 17
    %_113 = bitcast i8* %_112 to i8***
    %_114 = load i8**, i8*** %_113
    %_115 = getelementptr i8*, i8** %_114, i32 17
    %_116 = load i8*, i8** %_115
    %_117 = bitcast i8* %_116 to i32 (i8*, i32)*
    %_118 = call i32 %_117(i8* %_112, i32 12)
    call void @print_int(i32 %_118) 
    %_119 = load i8*, i8** %root
    ; %_119.Delete : 13
    %_120 = bitcast i8* %_119 to i8***
    %_121 = load i8**, i8*** %_120
    %_122 = getelementptr i8*, i8** %_121, i32 13
    %_123 = load i8*, i8** %_122
    %_124 = bitcast i8* %_123 to i1 (i8*, i32)*
    %_125 = call i1 %_124(i8* %_119, i32 12)
    store i1 %_125, i1* %ntb
    %_126 = load i8*, i8** %root
    ; %_126.Print : 18
    %_127 = bitcast i8* %_126 to i8***
    %_128 = load i8**, i8*** %_127
    %_129 = getelementptr i8*, i8** %_128, i32 18
    %_130 = load i8*, i8** %_129
    %_131 = bitcast i8* %_130 to i1 (i8*)*
    %_132 = call i1 %_131(i8* %_126)
    store i1 %_132, i1* %ntb
    %_133 = load i8*, i8** %root
    ; %_133.Search : 17
    %_134 = bitcast i8* %_133 to i8***
    %_135 = load i8**, i8*** %_134
    %_136 = getelementptr i8*, i8** %_135, i32 17
    %_137 = load i8*, i8** %_136
    %_138 = bitcast i8* %_137 to i32 (i8*, i32)*
    %_139 = call i32 %_138(i8* %_133, i32 12)
    call void @print_int(i32 %_139) 
    ret i32 0
}
define i1 @Tree.Init(i8* %this, i32 %.v_key) {
    %v_key = alloca i32
    store i32 %.v_key, i32* %v_key ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %v_key
    store i32 %_2, i32* %_1
    %_3 = getelementptr i8, i8* %this, i32 28
    %_4 = bitcast i8* %_3 to i1*
    store i1 false, i1* %_4
    %_5 = getelementptr i8, i8* %this, i32 29
    %_6 = bitcast i8* %_5 to i1*
    store i1 false, i1* %_6
    ret i1 true
}
define i1 @Tree.SetRight(i8* %this, i8* %.rn) {
    %rn = alloca i8*
    store i8* %.rn, i8** %rn ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %rn
    store i8* %_2, i8** %_1
    ret i1 true
}
define i1 @Tree.SetLeft(i8* %this, i8* %.ln) {
    %ln = alloca i8*
    store i8* %.ln, i8** %ln ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 8
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %ln
    store i8* %_2, i8** %_1
    ret i1 true
}
define i8* @Tree.GetRight(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %_1
    ret i8* %_2
}
define i8* @Tree.GetLeft(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 8
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %_1
    ret i8* %_2
}
define i32 @Tree.GetKey(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %_1
    ret i32 %_2
}
define i1 @Tree.SetKey(i8* %this, i32 %.v_key) {
    %v_key = alloca i32
    store i32 %.v_key, i32* %v_key ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %v_key
    store i32 %_2, i32* %_1
    ret i1 true
}
define i1 @Tree.GetHas_Right(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 29
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %_1
    ret i1 %_2
}
define i1 @Tree.GetHas_Left(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 28
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %_1
    ret i1 %_2
}
define i1 @Tree.SetHas_Left(i8* %this, i1 %.val) {
    %val = alloca i1
    store i1 %.val, i1* %val ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 28
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %val
    store i1 %_2, i1* %_1
    ret i1 true
}
define i1 @Tree.SetHas_Right(i8* %this, i1 %.val) {
    %val = alloca i1
    store i1 %.val, i1* %val ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 29
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %val
    store i1 %_2, i1* %_1
    ret i1 true
}
define i1 @Tree.Compare(i8* %this, i32 %.num1, i32 %.num2) {
    %num1 = alloca i32
    store i32 %.num1, i32* %num1 ; add the parameter to the stack

    %num2 = alloca i32
    store i32 %.num2, i32* %num2 ; add the parameter to the stack

    %ntb = alloca i1
    %nti = alloca i32
    store i1 false, i1* %ntb
    %_0 = load i32, i32* %num2
    %_1 = add i32 %_0, 1
    store i32 %_1, i32* %nti
    %_2 = load i32, i32* %num1
    %_3 = load i32, i32* %num2
    %_4 = icmp slt i32 %_2, %_3
    br i1 %_4, label %_5, label %_6
_5:
    store i1 false, i1* %ntb
    br label %_7
_6:
    %_8 = load i32, i32* %num1
    %_9 = load i32, i32* %nti
    %_10 = icmp slt i32 %_8, %_9
    %_11 = icmp eq i1 %_10, false
    br i1 %_11, label %_12, label %_13
_12:
    store i1 false, i1* %ntb
    br label %_14
_13:
    store i1 true, i1* %ntb
    br label %_14
_14:
    br label %_7
_7:
    %_15 = load i1, i1* %ntb
    ret i1 %_15
}
define i1 @Tree.Insert(i8* %this, i32 %.v_key) {
    %v_key = alloca i32
    store i32 %.v_key, i32* %v_key ; add the parameter to the stack

    %new_node = alloca i8*
    %ntb = alloca i1
    %current_node = alloca i8*
    %cont = alloca i1
    %key_aux = alloca i32
    %_0 = call i8* @calloc(i32 1, i32 38)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [21 x i8*], [21 x i8*]* @.Tree_vtable, i32 0, i32 0
    store i8** %_2, i8*** %_1
    store i8* %_0, i8** %new_node
    %_3 = load i8*, i8** %new_node
    ; %_3.Init : 0
    %_4 = bitcast i8* %_3 to i8***
    %_5 = load i8**, i8*** %_4
    %_6 = getelementptr i8*, i8** %_5, i32 0
    %_7 = load i8*, i8** %_6
    %_8 = bitcast i8* %_7 to i1 (i8*, i32)*
    %_9 = load i32, i32* %v_key
    %_10 = call i1 %_8(i8* %_3, i32 %_9)
    store i1 %_10, i1* %ntb
    store i8* %this, i8** %current_node
    store i1 true, i1* %cont
    br label %_11
_11:
    %_14 = load i1, i1* %cont
    br i1 %_14, label %_12, label %_13
_12:
    %_15 = load i8*, i8** %current_node
    ; %_15.GetKey : 5
    %_16 = bitcast i8* %_15 to i8***
    %_17 = load i8**, i8*** %_16
    %_18 = getelementptr i8*, i8** %_17, i32 5
    %_19 = load i8*, i8** %_18
    %_20 = bitcast i8* %_19 to i32 (i8*)*
    %_21 = call i32 %_20(i8* %_15)
    store i32 %_21, i32* %key_aux
    %_22 = load i32, i32* %v_key
    %_23 = load i32, i32* %key_aux
    %_24 = icmp slt i32 %_22, %_23
    br i1 %_24, label %_25, label %_26
_25:
    %_28 = load i8*, i8** %current_node
    ; %_28.GetHas_Left : 8
    %_29 = bitcast i8* %_28 to i8***
    %_30 = load i8**, i8*** %_29
    %_31 = getelementptr i8*, i8** %_30, i32 8
    %_32 = load i8*, i8** %_31
    %_33 = bitcast i8* %_32 to i1 (i8*)*
    %_34 = call i1 %_33(i8* %_28)
    br i1 %_34, label %_35, label %_36
_35:
    %_38 = load i8*, i8** %current_node
    ; %_38.GetLeft : 4
    %_39 = bitcast i8* %_38 to i8***
    %_40 = load i8**, i8*** %_39
    %_41 = getelementptr i8*, i8** %_40, i32 4
    %_42 = load i8*, i8** %_41
    %_43 = bitcast i8* %_42 to i8* (i8*)*
    %_44 = call i8* %_43(i8* %_38)
    store i8* %_44, i8** %current_node
    br label %_37
_36:
    store i1 false, i1* %cont
    %_45 = load i8*, i8** %current_node
    ; %_45.SetHas_Left : 9
    %_46 = bitcast i8* %_45 to i8***
    %_47 = load i8**, i8*** %_46
    %_48 = getelementptr i8*, i8** %_47, i32 9
    %_49 = load i8*, i8** %_48
    %_50 = bitcast i8* %_49 to i1 (i8*, i1)*
    %_51 = call i1 %_50(i8* %_45, i1 true)
    store i1 %_51, i1* %ntb
    %_52 = load i8*, i8** %current_node
    ; %_52.SetLeft : 2
    %_53 = bitcast i8* %_52 to i8***
    %_54 = load i8**, i8*** %_53
    %_55 = getelementptr i8*, i8** %_54, i32 2
    %_56 = load i8*, i8** %_55
    %_57 = bitcast i8* %_56 to i1 (i8*, i8*)*
    %_58 = load i8*, i8** %new_node
    %_59 = call i1 %_57(i8* %_52, i8* %_58)
    store i1 %_59, i1* %ntb
    br label %_37
_37:
    br label %_27
_26:
    %_60 = load i8*, i8** %current_node
    ; %_60.GetHas_Right : 7
    %_61 = bitcast i8* %_60 to i8***
    %_62 = load i8**, i8*** %_61
    %_63 = getelementptr i8*, i8** %_62, i32 7
    %_64 = load i8*, i8** %_63
    %_65 = bitcast i8* %_64 to i1 (i8*)*
    %_66 = call i1 %_65(i8* %_60)
    br i1 %_66, label %_67, label %_68
_67:
    %_70 = load i8*, i8** %current_node
    ; %_70.GetRight : 3
    %_71 = bitcast i8* %_70 to i8***
    %_72 = load i8**, i8*** %_71
    %_73 = getelementptr i8*, i8** %_72, i32 3
    %_74 = load i8*, i8** %_73
    %_75 = bitcast i8* %_74 to i8* (i8*)*
    %_76 = call i8* %_75(i8* %_70)
    store i8* %_76, i8** %current_node
    br label %_69
_68:
    store i1 false, i1* %cont
    %_77 = load i8*, i8** %current_node
    ; %_77.SetHas_Right : 10
    %_78 = bitcast i8* %_77 to i8***
    %_79 = load i8**, i8*** %_78
    %_80 = getelementptr i8*, i8** %_79, i32 10
    %_81 = load i8*, i8** %_80
    %_82 = bitcast i8* %_81 to i1 (i8*, i1)*
    %_83 = call i1 %_82(i8* %_77, i1 true)
    store i1 %_83, i1* %ntb
    %_84 = load i8*, i8** %current_node
    ; %_84.SetRight : 1
    %_85 = bitcast i8* %_84 to i8***
    %_86 = load i8**, i8*** %_85
    %_87 = getelementptr i8*, i8** %_86, i32 1
    %_88 = load i8*, i8** %_87
    %_89 = bitcast i8* %_88 to i1 (i8*, i8*)*
    %_90 = load i8*, i8** %new_node
    %_91 = call i1 %_89(i8* %_84, i8* %_90)
    store i1 %_91, i1* %ntb
    br label %_69
_69:
    br label %_27
_27:
    br label %_11
_13:
    ret i1 true
}
define i1 @Tree.Delete(i8* %this, i32 %.v_key) {
    %v_key = alloca i32
    store i32 %.v_key, i32* %v_key ; add the parameter to the stack

    %current_node = alloca i8*
    %parent_node = alloca i8*
    %cont = alloca i1
    %found = alloca i1
    %ntb = alloca i1
    %is_root = alloca i1
    %key_aux = alloca i32
    store i8* %this, i8** %current_node
    store i8* %this, i8** %parent_node
    store i1 true, i1* %cont
    store i1 false, i1* %found
    store i1 true, i1* %is_root
    br label %_0
_0:
    %_3 = load i1, i1* %cont
    br i1 %_3, label %_1, label %_2
_1:
    %_4 = load i8*, i8** %current_node
    ; %_4.GetKey : 5
    %_5 = bitcast i8* %_4 to i8***
    %_6 = load i8**, i8*** %_5
    %_7 = getelementptr i8*, i8** %_6, i32 5
    %_8 = load i8*, i8** %_7
    %_9 = bitcast i8* %_8 to i32 (i8*)*
    %_10 = call i32 %_9(i8* %_4)
    store i32 %_10, i32* %key_aux
    %_11 = load i32, i32* %v_key
    %_12 = load i32, i32* %key_aux
    %_13 = icmp slt i32 %_11, %_12
    br i1 %_13, label %_14, label %_15
_14:
    %_17 = load i8*, i8** %current_node
    ; %_17.GetHas_Left : 8
    %_18 = bitcast i8* %_17 to i8***
    %_19 = load i8**, i8*** %_18
    %_20 = getelementptr i8*, i8** %_19, i32 8
    %_21 = load i8*, i8** %_20
    %_22 = bitcast i8* %_21 to i1 (i8*)*
    %_23 = call i1 %_22(i8* %_17)
    br i1 %_23, label %_24, label %_25
_24:
    %_27 = load i8*, i8** %current_node
    store i8* %_27, i8** %parent_node
    %_28 = load i8*, i8** %current_node
    ; %_28.GetLeft : 4
    %_29 = bitcast i8* %_28 to i8***
    %_30 = load i8**, i8*** %_29
    %_31 = getelementptr i8*, i8** %_30, i32 4
    %_32 = load i8*, i8** %_31
    %_33 = bitcast i8* %_32 to i8* (i8*)*
    %_34 = call i8* %_33(i8* %_28)
    store i8* %_34, i8** %current_node
    br label %_26
_25:
    store i1 false, i1* %cont
    br label %_26
_26:
    br label %_16
_15:
    %_35 = load i32, i32* %key_aux
    %_36 = load i32, i32* %v_key
    %_37 = icmp slt i32 %_35, %_36
    br i1 %_37, label %_38, label %_39
_38:
    %_41 = load i8*, i8** %current_node
    ; %_41.GetHas_Right : 7
    %_42 = bitcast i8* %_41 to i8***
    %_43 = load i8**, i8*** %_42
    %_44 = getelementptr i8*, i8** %_43, i32 7
    %_45 = load i8*, i8** %_44
    %_46 = bitcast i8* %_45 to i1 (i8*)*
    %_47 = call i1 %_46(i8* %_41)
    br i1 %_47, label %_48, label %_49
_48:
    %_51 = load i8*, i8** %current_node
    store i8* %_51, i8** %parent_node
    %_52 = load i8*, i8** %current_node
    ; %_52.GetRight : 3
    %_53 = bitcast i8* %_52 to i8***
    %_54 = load i8**, i8*** %_53
    %_55 = getelementptr i8*, i8** %_54, i32 3
    %_56 = load i8*, i8** %_55
    %_57 = bitcast i8* %_56 to i8* (i8*)*
    %_58 = call i8* %_57(i8* %_52)
    store i8* %_58, i8** %current_node
    br label %_50
_49:
    store i1 false, i1* %cont
    br label %_50
_50:
    br label %_40
_39:
    %_59 = load i1, i1* %is_root
    br i1 %_59, label %_60, label %_61
_60:
    br label %_63
_63:
    %_65 = load i8*, i8** %current_node
    ; %_65.GetHas_Right : 7
    %_66 = bitcast i8* %_65 to i8***
    %_67 = load i8**, i8*** %_66
    %_68 = getelementptr i8*, i8** %_67, i32 7
    %_69 = load i8*, i8** %_68
    %_70 = bitcast i8* %_69 to i1 (i8*)*
    %_71 = call i1 %_70(i8* %_65)
    %_72 = icmp eq i1 %_71, false
    br i1 %_72, label %_73, label %_64
_73:
    %_74 = load i8*, i8** %current_node
    ; %_74.GetHas_Left : 8
    %_75 = bitcast i8* %_74 to i8***
    %_76 = load i8**, i8*** %_75
    %_77 = getelementptr i8*, i8** %_76, i32 8
    %_78 = load i8*, i8** %_77
    %_79 = bitcast i8* %_78 to i1 (i8*)*
    %_80 = call i1 %_79(i8* %_74)
    %_81 = icmp eq i1 %_80, false
    br label %_64
_64:
    %_82 = phi i1 [ false, %_63 ], [ %_81, %_73 ]
    br i1 %_82, label %_83, label %_84
_83:
    store i1 true, i1* %ntb
    br label %_85
_84:
    ; %this.Remove : 14
    %_86 = bitcast i8* %this to i8***
    %_87 = load i8**, i8*** %_86
    %_88 = getelementptr i8*, i8** %_87, i32 14
    %_89 = load i8*, i8** %_88
    %_90 = bitcast i8* %_89 to i1 (i8*, i8*, i8*)*
    %_91 = load i8*, i8** %parent_node
    %_92 = load i8*, i8** %current_node
    %_93 = call i1 %_90(i8* %this, i8* %_91, i8* %_92)
    store i1 %_93, i1* %ntb
    br label %_85
_85:
    br label %_62
_61:
    ; %this.Remove : 14
    %_94 = bitcast i8* %this to i8***
    %_95 = load i8**, i8*** %_94
    %_96 = getelementptr i8*, i8** %_95, i32 14
    %_97 = load i8*, i8** %_96
    %_98 = bitcast i8* %_97 to i1 (i8*, i8*, i8*)*
    %_99 = load i8*, i8** %parent_node
    %_100 = load i8*, i8** %current_node
    %_101 = call i1 %_98(i8* %this, i8* %_99, i8* %_100)
    store i1 %_101, i1* %ntb
    br label %_62
_62:
    store i1 true, i1* %found
    store i1 false, i1* %cont
    br label %_40
_40:
    br label %_16
_16:
    store i1 false, i1* %is_root
    br label %_0
_2:
    %_102 = load i1, i1* %found
    ret i1 %_102
}
define i1 @Tree.Remove(i8* %this, i8* %.p_node, i8* %.c_node) {
    %p_node = alloca i8*
    store i8* %.p_node, i8** %p_node ; add the parameter to the stack

    %c_node = alloca i8*
    store i8* %.c_node, i8** %c_node ; add the parameter to the stack

    %ntb = alloca i1
    %auxkey1 = alloca i32
    %auxkey2 = alloca i32
    %_0 = load i8*, i8** %c_node
    ; %_0.GetHas_Left : 8
    %_1 = bitcast i8* %_0 to i8***
    %_2 = load i8**, i8*** %_1
    %_3 = getelementptr i8*, i8** %_2, i32 8
    %_4 = load i8*, i8** %_3
    %_5 = bitcast i8* %_4 to i1 (i8*)*
    %_6 = call i1 %_5(i8* %_0)
    br i1 %_6, label %_7, label %_8
_7:
    ; %this.RemoveLeft : 16
    %_10 = bitcast i8* %this to i8***
    %_11 = load i8**, i8*** %_10
    %_12 = getelementptr i8*, i8** %_11, i32 16
    %_13 = load i8*, i8** %_12
    %_14 = bitcast i8* %_13 to i1 (i8*, i8*, i8*)*
    %_15 = load i8*, i8** %p_node
    %_16 = load i8*, i8** %c_node
    %_17 = call i1 %_14(i8* %this, i8* %_15, i8* %_16)
    store i1 %_17, i1* %ntb
    br label %_9
_8:
    %_18 = load i8*, i8** %c_node
    ; %_18.GetHas_Right : 7
    %_19 = bitcast i8* %_18 to i8***
    %_20 = load i8**, i8*** %_19
    %_21 = getelementptr i8*, i8** %_20, i32 7
    %_22 = load i8*, i8** %_21
    %_23 = bitcast i8* %_22 to i1 (i8*)*
    %_24 = call i1 %_23(i8* %_18)
    br i1 %_24, label %_25, label %_26
_25:
    ; %this.RemoveRight : 15
    %_28 = bitcast i8* %this to i8***
    %_29 = load i8**, i8*** %_28
    %_30 = getelementptr i8*, i8** %_29, i32 15
    %_31 = load i8*, i8** %_30
    %_32 = bitcast i8* %_31 to i1 (i8*, i8*, i8*)*
    %_33 = load i8*, i8** %p_node
    %_34 = load i8*, i8** %c_node
    %_35 = call i1 %_32(i8* %this, i8* %_33, i8* %_34)
    store i1 %_35, i1* %ntb
    br label %_27
_26:
    %_36 = load i8*, i8** %c_node
    ; %_36.GetKey : 5
    %_37 = bitcast i8* %_36 to i8***
    %_38 = load i8**, i8*** %_37
    %_39 = getelementptr i8*, i8** %_38, i32 5
    %_40 = load i8*, i8** %_39
    %_41 = bitcast i8* %_40 to i32 (i8*)*
    %_42 = call i32 %_41(i8* %_36)
    store i32 %_42, i32* %auxkey1
    %_43 = load i8*, i8** %p_node
    ; %_43.GetLeft : 4
    %_44 = bitcast i8* %_43 to i8***
    %_45 = load i8**, i8*** %_44
    %_46 = getelementptr i8*, i8** %_45, i32 4
    %_47 = load i8*, i8** %_46
    %_48 = bitcast i8* %_47 to i8* (i8*)*
    %_49 = call i8* %_48(i8* %_43)
    ; %_49.GetKey : 5
    %_50 = bitcast i8* %_49 to i8***
    %_51 = load i8**, i8*** %_50
    %_52 = getelementptr i8*, i8** %_51, i32 5
    %_53 = load i8*, i8** %_52
    %_54 = bitcast i8* %_53 to i32 (i8*)*
    %_55 = call i32 %_54(i8* %_49)
    store i32 %_55, i32* %auxkey2
    ; %this.Compare : 11
    %_56 = bitcast i8* %this to i8***
    %_57 = load i8**, i8*** %_56
    %_58 = getelementptr i8*, i8** %_57, i32 11
    %_59 = load i8*, i8** %_58
    %_60 = bitcast i8* %_59 to i1 (i8*, i32, i32)*
    %_61 = load i32, i32* %auxkey1
    %_62 = load i32, i32* %auxkey2
    %_63 = call i1 %_60(i8* %this, i32 %_61, i32 %_62)
    br i1 %_63, label %_64, label %_65
_64:
    %_67 = load i8*, i8** %p_node
    ; %_67.SetLeft : 2
    %_68 = bitcast i8* %_67 to i8***
    %_69 = load i8**, i8*** %_68
    %_70 = getelementptr i8*, i8** %_69, i32 2
    %_71 = load i8*, i8** %_70
    %_72 = bitcast i8* %_71 to i1 (i8*, i8*)*
    %_73 = getelementptr i8, i8* %this, i32 30
    %_74 = bitcast i8* %_73 to i8**
    %_75 = load i8*, i8** %_74
    %_76 = call i1 %_72(i8* %_67, i8* %_75)
    store i1 %_76, i1* %ntb
    %_77 = load i8*, i8** %p_node
    ; %_77.SetHas_Left : 9
    %_78 = bitcast i8* %_77 to i8***
    %_79 = load i8**, i8*** %_78
    %_80 = getelementptr i8*, i8** %_79, i32 9
    %_81 = load i8*, i8** %_80
    %_82 = bitcast i8* %_81 to i1 (i8*, i1)*
    %_83 = call i1 %_82(i8* %_77, i1 false)
    store i1 %_83, i1* %ntb
    br label %_66
_65:
    %_84 = load i8*, i8** %p_node
    ; %_84.SetRight : 1
    %_85 = bitcast i8* %_84 to i8***
    %_86 = load i8**, i8*** %_85
    %_87 = getelementptr i8*, i8** %_86, i32 1
    %_88 = load i8*, i8** %_87
    %_89 = bitcast i8* %_88 to i1 (i8*, i8*)*
    %_90 = getelementptr i8, i8* %this, i32 30
    %_91 = bitcast i8* %_90 to i8**
    %_92 = load i8*, i8** %_91
    %_93 = call i1 %_89(i8* %_84, i8* %_92)
    store i1 %_93, i1* %ntb
    %_94 = load i8*, i8** %p_node
    ; %_94.SetHas_Right : 10
    %_95 = bitcast i8* %_94 to i8***
    %_96 = load i8**, i8*** %_95
    %_97 = getelementptr i8*, i8** %_96, i32 10
    %_98 = load i8*, i8** %_97
    %_99 = bitcast i8* %_98 to i1 (i8*, i1)*
    %_100 = call i1 %_99(i8* %_94, i1 false)
    store i1 %_100, i1* %ntb
    br label %_66
_66:
    br label %_27
_27:
    br label %_9
_9:
    ret i1 true
}
define i1 @Tree.RemoveRight(i8* %this, i8* %.p_node, i8* %.c_node) {
    %p_node = alloca i8*
    store i8* %.p_node, i8** %p_node ; add the parameter to the stack

    %c_node = alloca i8*
    store i8* %.c_node, i8** %c_node ; add the parameter to the stack

    %ntb = alloca i1
    br label %_0
_0:
    %_3 = load i8*, i8** %c_node
    ; %_3.GetHas_Right : 7
    %_4 = bitcast i8* %_3 to i8***
    %_5 = load i8**, i8*** %_4
    %_6 = getelementptr i8*, i8** %_5, i32 7
    %_7 = load i8*, i8** %_6
    %_8 = bitcast i8* %_7 to i1 (i8*)*
    %_9 = call i1 %_8(i8* %_3)
    br i1 %_9, label %_1, label %_2
_1:
    %_10 = load i8*, i8** %c_node
    ; %_10.SetKey : 6
    %_11 = bitcast i8* %_10 to i8***
    %_12 = load i8**, i8*** %_11
    %_13 = getelementptr i8*, i8** %_12, i32 6
    %_14 = load i8*, i8** %_13
    %_15 = bitcast i8* %_14 to i1 (i8*, i32)*
    %_16 = load i8*, i8** %c_node
    ; %_16.GetRight : 3
    %_17 = bitcast i8* %_16 to i8***
    %_18 = load i8**, i8*** %_17
    %_19 = getelementptr i8*, i8** %_18, i32 3
    %_20 = load i8*, i8** %_19
    %_21 = bitcast i8* %_20 to i8* (i8*)*
    %_22 = call i8* %_21(i8* %_16)
    ; %_22.GetKey : 5
    %_23 = bitcast i8* %_22 to i8***
    %_24 = load i8**, i8*** %_23
    %_25 = getelementptr i8*, i8** %_24, i32 5
    %_26 = load i8*, i8** %_25
    %_27 = bitcast i8* %_26 to i32 (i8*)*
    %_28 = call i32 %_27(i8* %_22)
    %_29 = call i1 %_15(i8* %_10, i32 %_28)
    store i1 %_29, i1* %ntb
    %_30 = load i8*, i8** %c_node
    store i8* %_30, i8** %p_node
    %_31 = load i8*, i8** %c_node
    ; %_31.GetRight : 3
    %_32 = bitcast i8* %_31 to i8***
    %_33 = load i8**, i8*** %_32
    %_34 = getelementptr i8*, i8** %_33, i32 3
    %_35 = load i8*, i8** %_34
    %_36 = bitcast i8* %_35 to i8* (i8*)*
    %_37 = call i8* %_36(i8* %_31)
    store i8* %_37, i8** %c_node
    br label %_0
_2:
    %_38 = load i8*, i8** %p_node
    ; %_38.SetRight : 1
    %_39 = bitcast i8* %_38 to i8***
    %_40 = load i8**, i8*** %_39
    %_41 = getelementptr i8*, i8** %_40, i32 1
    %_42 = load i8*, i8** %_41
    %_43 = bitcast i8* %_42 to i1 (i8*, i8*)*
    %_44 = getelementptr i8, i8* %this, i32 30
    %_45 = bitcast i8* %_44 to i8**
    %_46 = load i8*, i8** %_45
    %_47 = call i1 %_43(i8* %_38, i8* %_46)
    store i1 %_47, i1* %ntb
    %_48 = load i8*, i8** %p_node
    ; %_48.SetHas_Right : 10
    %_49 = bitcast i8* %_48 to i8***
    %_50 = load i8**, i8*** %_49
    %_51 = getelementptr i8*, i8** %_50, i32 10
    %_52 = load i8*, i8** %_51
    %_53 = bitcast i8* %_52 to i1 (i8*, i1)*
    %_54 = call i1 %_53(i8* %_48, i1 false)
    store i1 %_54, i1* %ntb
    ret i1 true
}
define i1 @Tree.RemoveLeft(i8* %this, i8* %.p_node, i8* %.c_node) {
    %p_node = alloca i8*
    store i8* %.p_node, i8** %p_node ; add the parameter to the stack

    %c_node = alloca i8*
    store i8* %.c_node, i8** %c_node ; add the parameter to the stack

    %ntb = alloca i1
    br label %_0
_0:
    %_3 = load i8*, i8** %c_node
    ; %_3.GetHas_Left : 8
    %_4 = bitcast i8* %_3 to i8***
    %_5 = load i8**, i8*** %_4
    %_6 = getelementptr i8*, i8** %_5, i32 8
    %_7 = load i8*, i8** %_6
    %_8 = bitcast i8* %_7 to i1 (i8*)*
    %_9 = call i1 %_8(i8* %_3)
    br i1 %_9, label %_1, label %_2
_1:
    %_10 = load i8*, i8** %c_node
    ; %_10.SetKey : 6
    %_11 = bitcast i8* %_10 to i8***
    %_12 = load i8**, i8*** %_11
    %_13 = getelementptr i8*, i8** %_12, i32 6
    %_14 = load i8*, i8** %_13
    %_15 = bitcast i8* %_14 to i1 (i8*, i32)*
    %_16 = load i8*, i8** %c_node
    ; %_16.GetLeft : 4
    %_17 = bitcast i8* %_16 to i8***
    %_18 = load i8**, i8*** %_17
    %_19 = getelementptr i8*, i8** %_18, i32 4
    %_20 = load i8*, i8** %_19
    %_21 = bitcast i8* %_20 to i8* (i8*)*
    %_22 = call i8* %_21(i8* %_16)
    ; %_22.GetKey : 5
    %_23 = bitcast i8* %_22 to i8***
    %_24 = load i8**, i8*** %_23
    %_25 = getelementptr i8*, i8** %_24, i32 5
    %_26 = load i8*, i8** %_25
    %_27 = bitcast i8* %_26 to i32 (i8*)*
    %_28 = call i32 %_27(i8* %_22)
    %_29 = call i1 %_15(i8* %_10, i32 %_28)
    store i1 %_29, i1* %ntb
    %_30 = load i8*, i8** %c_node
    store i8* %_30, i8** %p_node
    %_31 = load i8*, i8** %c_node
    ; %_31.GetLeft : 4
    %_32 = bitcast i8* %_31 to i8***
    %_33 = load i8**, i8*** %_32
    %_34 = getelementptr i8*, i8** %_33, i32 4
    %_35 = load i8*, i8** %_34
    %_36 = bitcast i8* %_35 to i8* (i8*)*
    %_37 = call i8* %_36(i8* %_31)
    store i8* %_37, i8** %c_node
    br label %_0
_2:
    %_38 = load i8*, i8** %p_node
    ; %_38.SetLeft : 2
    %_39 = bitcast i8* %_38 to i8***
    %_40 = load i8**, i8*** %_39
    %_41 = getelementptr i8*, i8** %_40, i32 2
    %_42 = load i8*, i8** %_41
    %_43 = bitcast i8* %_42 to i1 (i8*, i8*)*
    %_44 = getelementptr i8, i8* %this, i32 30
    %_45 = bitcast i8* %_44 to i8**
    %_46 = load i8*, i8** %_45
    %_47 = call i1 %_43(i8* %_38, i8* %_46)
    store i1 %_47, i1* %ntb
    %_48 = load i8*, i8** %p_node
    ; %_48.SetHas_Left : 9
    %_49 = bitcast i8* %_48 to i8***
    %_50 = load i8**, i8*** %_49
    %_51 = getelementptr i8*, i8** %_50, i32 9
    %_52 = load i8*, i8** %_51
    %_53 = bitcast i8* %_52 to i1 (i8*, i1)*
    %_54 = call i1 %_53(i8* %_48, i1 false)
    store i1 %_54, i1* %ntb
    ret i1 true
}
define i32 @Tree.Search(i8* %this, i32 %.v_key) {
    %v_key = alloca i32
    store i32 %.v_key, i32* %v_key ; add the parameter to the stack

    %current_node = alloca i8*
    %ifound = alloca i32
    %cont = alloca i1
    %key_aux = alloca i32
    store i8* %this, i8** %current_node
    store i1 true, i1* %cont
    store i32 0, i32* %ifound
    br label %_0
_0:
    %_3 = load i1, i1* %cont
    br i1 %_3, label %_1, label %_2
_1:
    %_4 = load i8*, i8** %current_node
    ; %_4.GetKey : 5
    %_5 = bitcast i8* %_4 to i8***
    %_6 = load i8**, i8*** %_5
    %_7 = getelementptr i8*, i8** %_6, i32 5
    %_8 = load i8*, i8** %_7
    %_9 = bitcast i8* %_8 to i32 (i8*)*
    %_10 = call i32 %_9(i8* %_4)
    store i32 %_10, i32* %key_aux
    %_11 = load i32, i32* %v_key
    %_12 = load i32, i32* %key_aux
    %_13 = icmp slt i32 %_11, %_12
    br i1 %_13, label %_14, label %_15
_14:
    %_17 = load i8*, i8** %current_node
    ; %_17.GetHas_Left : 8
    %_18 = bitcast i8* %_17 to i8***
    %_19 = load i8**, i8*** %_18
    %_20 = getelementptr i8*, i8** %_19, i32 8
    %_21 = load i8*, i8** %_20
    %_22 = bitcast i8* %_21 to i1 (i8*)*
    %_23 = call i1 %_22(i8* %_17)
    br i1 %_23, label %_24, label %_25
_24:
    %_27 = load i8*, i8** %current_node
    ; %_27.GetLeft : 4
    %_28 = bitcast i8* %_27 to i8***
    %_29 = load i8**, i8*** %_28
    %_30 = getelementptr i8*, i8** %_29, i32 4
    %_31 = load i8*, i8** %_30
    %_32 = bitcast i8* %_31 to i8* (i8*)*
    %_33 = call i8* %_32(i8* %_27)
    store i8* %_33, i8** %current_node
    br label %_26
_25:
    store i1 false, i1* %cont
    br label %_26
_26:
    br label %_16
_15:
    %_34 = load i32, i32* %key_aux
    %_35 = load i32, i32* %v_key
    %_36 = icmp slt i32 %_34, %_35
    br i1 %_36, label %_37, label %_38
_37:
    %_40 = load i8*, i8** %current_node
    ; %_40.GetHas_Right : 7
    %_41 = bitcast i8* %_40 to i8***
    %_42 = load i8**, i8*** %_41
    %_43 = getelementptr i8*, i8** %_42, i32 7
    %_44 = load i8*, i8** %_43
    %_45 = bitcast i8* %_44 to i1 (i8*)*
    %_46 = call i1 %_45(i8* %_40)
    br i1 %_46, label %_47, label %_48
_47:
    %_50 = load i8*, i8** %current_node
    ; %_50.GetRight : 3
    %_51 = bitcast i8* %_50 to i8***
    %_52 = load i8**, i8*** %_51
    %_53 = getelementptr i8*, i8** %_52, i32 3
    %_54 = load i8*, i8** %_53
    %_55 = bitcast i8* %_54 to i8* (i8*)*
    %_56 = call i8* %_55(i8* %_50)
    store i8* %_56, i8** %current_node
    br label %_49
_48:
    store i1 false, i1* %cont
    br label %_49
_49:
    br label %_39
_38:
    store i32 1, i32* %ifound
    store i1 false, i1* %cont
    br label %_39
_39:
    br label %_16
_16:
    br label %_0
_2:
    %_57 = load i32, i32* %ifound
    ret i32 %_57
}
define i1 @Tree.Print(i8* %this) {
    %ntb = alloca i1
    %current_node = alloca i8*
    store i8* %this, i8** %current_node
    ; %this.RecPrint : 19
    %_0 = bitcast i8* %this to i8***
    %_1 = load i8**, i8*** %_0
    %_2 = getelementptr i8*, i8** %_1, i32 19
    %_3 = load i8*, i8** %_2
    %_4 = bitcast i8* %_3 to i1 (i8*, i8*)*
    %_5 = load i8*, i8** %current_node
    %_6 = call i1 %_4(i8* %this, i8* %_5)
    store i1 %_6, i1* %ntb
    ret i1 true
}
define i1 @Tree.RecPrint(i8* %this, i8* %.node) {
    %node = alloca i8*
    store i8* %.node, i8** %node ; add the parameter to the stack

    %ntb = alloca i1
    %_0 = load i8*, i8** %node
    ; %_0.GetHas_Left : 8
    %_1 = bitcast i8* %_0 to i8***
    %_2 = load i8**, i8*** %_1
    %_3 = getelementptr i8*, i8** %_2, i32 8
    %_4 = load i8*, i8** %_3
    %_5 = bitcast i8* %_4 to i1 (i8*)*
    %_6 = call i1 %_5(i8* %_0)
    br i1 %_6, label %_7, label %_8
_7:
    ; %this.RecPrint : 19
    %_10 = bitcast i8* %this to i8***
    %_11 = load i8**, i8*** %_10
    %_12 = getelementptr i8*, i8** %_11, i32 19
    %_13 = load i8*, i8** %_12
    %_14 = bitcast i8* %_13 to i1 (i8*, i8*)*
    %_15 = load i8*, i8** %node
    ; %_15.GetLeft : 4
    %_16 = bitcast i8* %_15 to i8***
    %_17 = load i8**, i8*** %_16
    %_18 = getelementptr i8*, i8** %_17, i32 4
    %_19 = load i8*, i8** %_18
    %_20 = bitcast i8* %_19 to i8* (i8*)*
    %_21 = call i8* %_20(i8* %_15)
    %_22 = call i1 %_14(i8* %this, i8* %_21)
    store i1 %_22, i1* %ntb
    br label %_9
_8:
    store i1 true, i1* %ntb
    br label %_9
_9:
    %_23 = load i8*, i8** %node
    ; %_23.GetKey : 5
    %_24 = bitcast i8* %_23 to i8***
    %_25 = load i8**, i8*** %_24
    %_26 = getelementptr i8*, i8** %_25, i32 5
    %_27 = load i8*, i8** %_26
    %_28 = bitcast i8* %_27 to i32 (i8*)*
    %_29 = call i32 %_28(i8* %_23)
    call void @print_int(i32 %_29) 
    %_30 = load i8*, i8** %node
    ; %_30.GetHas_Right : 7
    %_31 = bitcast i8* %_30 to i8***
    %_32 = load i8**, i8*** %_31
    %_33 = getelementptr i8*, i8** %_32, i32 7
    %_34 = load i8*, i8** %_33
    %_35 = bitcast i8* %_34 to i1 (i8*)*
    %_36 = call i1 %_35(i8* %_30)
    br i1 %_36, label %_37, label %_38
_37:
    ; %this.RecPrint : 19
    %_40 = bitcast i8* %this to i8***
    %_41 = load i8**, i8*** %_40
    %_42 = getelementptr i8*, i8** %_41, i32 19
    %_43 = load i8*, i8** %_42
    %_44 = bitcast i8* %_43 to i1 (i8*, i8*)*
    %_45 = load i8*, i8** %node
    ; %_45.GetRight : 3
    %_46 = bitcast i8* %_45 to i8***
    %_47 = load i8**, i8*** %_46
    %_48 = getelementptr i8*, i8** %_47, i32 3
    %_49 = load i8*, i8** %_48
    %_50 = bitcast i8* %_49 to i8* (i8*)*
    %_51 = call i8* %_50(i8* %_45)
    %_52 = call i1 %_44(i8* %this, i8* %_51)
    store i1 %_52, i1* %ntb
    br label %_39
_38:
    store i1 true, i1* %ntb
    br label %_39
_39:
    ret i1 true
}
define i32 @Tree.accept(i8* %this, i8* %.v) {
    %v = alloca i8*
    store i8* %.v, i8** %v ; add the parameter to the stack

    %nti = alloca i32
    call void @print_int(i32 333) 
    %_0 = load i8*, i8** %v
    ; %_0.visit : 0
    %_1 = bitcast i8* %_0 to i8***
    %_2 = load i8**, i8*** %_1
    %_3 = getelementptr i8*, i8** %_2, i32 0
    %_4 = load i8*, i8** %_3
    %_5 = bitcast i8* %_4 to i32 (i8*, i8*)*
    %_6 = call i32 %_5(i8* %_0, i8* %this)
    store i32 %_6, i32* %nti
    ret i32 0
}
define i32 @Visitor.visit(i8* %this, i8* %.n) {
    %n = alloca i8*
    store i8* %.n, i8** %n ; add the parameter to the stack

    %nti = alloca i32
    %_0 = load i8*, i8** %n
    ; %_0.GetHas_Right : 7
    %_1 = bitcast i8* %_0 to i8***
    %_2 = load i8**, i8*** %_1
    %_3 = getelementptr i8*, i8** %_2, i32 7
    %_4 = load i8*, i8** %_3
    %_5 = bitcast i8* %_4 to i1 (i8*)*
    %_6 = call i1 %_5(i8* %_0)
    br i1 %_6, label %_7, label %_8
_7:
    %_10 = getelementptr i8, i8* %this, i32 16
    %_11 = bitcast i8* %_10 to i8**
    %_12 = load i8*, i8** %n
    ; %_12.GetRight : 3
    %_13 = bitcast i8* %_12 to i8***
    %_14 = load i8**, i8*** %_13
    %_15 = getelementptr i8*, i8** %_14, i32 3
    %_16 = load i8*, i8** %_15
    %_17 = bitcast i8* %_16 to i8* (i8*)*
    %_18 = call i8* %_17(i8* %_12)
    store i8* %_18, i8** %_11
    %_19 = getelementptr i8, i8* %this, i32 16
    %_20 = bitcast i8* %_19 to i8**
    %_21 = load i8*, i8** %_20
    ; %_21.accept : 20
    %_22 = bitcast i8* %_21 to i8***
    %_23 = load i8**, i8*** %_22
    %_24 = getelementptr i8*, i8** %_23, i32 20
    %_25 = load i8*, i8** %_24
    %_26 = bitcast i8* %_25 to i32 (i8*, i8*)*
    %_27 = call i32 %_26(i8* %_21, i8* %this)
    store i32 %_27, i32* %nti
    br label %_9
_8:
    store i32 0, i32* %nti
    br label %_9
_9:
    %_28 = load i8*, i8** %n
    ; %_28.GetHas_Left : 8
    %_29 = bitcast i8* %_28 to i8***
    %_30 = load i8**, i8*** %_29
    %_31 = getelementptr i8*, i8** %_30, i32 8
    %_32 = load i8*, i8** %_31
    %_33 = bitcast i8* %_32 to i1 (i8*)*
    %_34 = call i1 %_33(i8* %_28)
    br i1 %_34, label %_35, label %_36
_35:
    %_38 = getelementptr i8, i8* %this, i32 8
    %_39 = bitcast i8* %_38 to i8**
    %_40 = load i8*, i8** %n
    ; %_40.GetLeft : 4
    %_41 = bitcast i8* %_40 to i8***
    %_42 = load i8**, i8*** %_41
    %_43 = getelementptr i8*, i8** %_42, i32 4
    %_44 = load i8*, i8** %_43
    %_45 = bitcast i8* %_44 to i8* (i8*)*
    %_46 = call i8* %_45(i8* %_40)
    store i8* %_46, i8** %_39
    %_47 = getelementptr i8, i8* %this, i32 8
    %_48 = bitcast i8* %_47 to i8**
    %_49 = load i8*, i8** %_48
    ; %_49.accept : 20
    %_50 = bitcast i8* %_49 to i8***
    %_51 = load i8**, i8*** %_50
    %_52 = getelementptr i8*, i8** %_51, i32 20
    %_53 = load i8*, i8** %_52
    %_54 = bitcast i8* %_53 to i32 (i8*, i8*)*
    %_55 = call i32 %_54(i8* %_49, i8* %this)
    store i32 %_55, i32* %nti
    br label %_37
_36:
    store i32 0, i32* %nti
    br label %_37
_37:
    ret i32 0
}
define i32 @MyVisitor.visit(i8* %this, i8* %.n) {
    %n = alloca i8*
    store i8* %.n, i8** %n ; add the parameter to the stack

    %nti = alloca i32
    %_0 = load i8*, i8** %n
    ; %_0.GetHas_Right : 7
    %_1 = bitcast i8* %_0 to i8***
    %_2 = load i8**, i8*** %_1
    %_3 = getelementptr i8*, i8** %_2, i32 7
    %_4 = load i8*, i8** %_3
    %_5 = bitcast i8* %_4 to i1 (i8*)*
    %_6 = call i1 %_5(i8* %_0)
    br i1 %_6, label %_7, label %_8
_7:
    %_10 = getelementptr i8, i8* %this, i32 16
    %_11 = bitcast i8* %_10 to i8**
    %_12 = load i8*, i8** %n
    ; %_12.GetRight : 3
    %_13 = bitcast i8* %_12 to i8***
    %_14 = load i8**, i8*** %_13
    %_15 = getelementptr i8*, i8** %_14, i32 3
    %_16 = load i8*, i8** %_15
    %_17 = bitcast i8* %_16 to i8* (i8*)*
    %_18 = call i8* %_17(i8* %_12)
    store i8* %_18, i8** %_11
    %_19 = getelementptr i8, i8* %this, i32 16
    %_20 = bitcast i8* %_19 to i8**
    %_21 = load i8*, i8** %_20
    ; %_21.accept : 20
    %_22 = bitcast i8* %_21 to i8***
    %_23 = load i8**, i8*** %_22
    %_24 = getelementptr i8*, i8** %_23, i32 20
    %_25 = load i8*, i8** %_24
    %_26 = bitcast i8* %_25 to i32 (i8*, i8*)*
    %_27 = call i32 %_26(i8* %_21, i8* %this)
    store i32 %_27, i32* %nti
    br label %_9
_8:
    store i32 0, i32* %nti
    br label %_9
_9:
    %_28 = load i8*, i8** %n
    ; %_28.GetKey : 5
    %_29 = bitcast i8* %_28 to i8***
    %_30 = load i8**, i8*** %_29
    %_31 = getelementptr i8*, i8** %_30, i32 5
    %_32 = load i8*, i8** %_31
    %_33 = bitcast i8* %_32 to i32 (i8*)*
    %_34 = call i32 %_33(i8* %_28)
    call void @print_int(i32 %_34) 
    %_35 = load i8*, i8** %n
    ; %_35.GetHas_Left : 8
    %_36 = bitcast i8* %_35 to i8***
    %_37 = load i8**, i8*** %_36
    %_38 = getelementptr i8*, i8** %_37, i32 8
    %_39 = load i8*, i8** %_38
    %_40 = bitcast i8* %_39 to i1 (i8*)*
    %_41 = call i1 %_40(i8* %_35)
    br i1 %_41, label %_42, label %_43
_42:
    %_45 = getelementptr i8, i8* %this, i32 8
    %_46 = bitcast i8* %_45 to i8**
    %_47 = load i8*, i8** %n
    ; %_47.GetLeft : 4
    %_48 = bitcast i8* %_47 to i8***
    %_49 = load i8**, i8*** %_48
    %_50 = getelementptr i8*, i8** %_49, i32 4
    %_51 = load i8*, i8** %_50
    %_52 = bitcast i8* %_51 to i8* (i8*)*
    %_53 = call i8* %_52(i8* %_47)
    store i8* %_53, i8** %_46
    %_54 = getelementptr i8, i8* %this, i32 8
    %_55 = bitcast i8* %_54 to i8**
    %_56 = load i8*, i8** %_55
    ; %_56.accept : 20
    %_57 = bitcast i8* %_56 to i8***
    %_58 = load i8**, i8*** %_57
    %_59 = getelementptr i8*, i8** %_58, i32 20
    %_60 = load i8*, i8** %_59
    %_61 = bitcast i8* %_60 to i32 (i8*, i8*)*
    %_62 = call i32 %_61(i8* %_56, i8* %this)
    store i32 %_62, i32* %nti
    br label %_44
_43:
    store i32 0, i32* %nti
    br label %_44
_44:
    ret i32 0
}
