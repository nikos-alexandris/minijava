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

@.LL_vtable = global [1 x i8*] [
    i8* bitcast (i32 (i8*)* @LL.Start to i8*)
]
@.Element_vtable = global [6 x i8*] [
    i8* bitcast (i1 (i8*, i32, i32, i1)* @Element.Init to i8*), 
    i8* bitcast (i32 (i8*)* @Element.GetAge to i8*), 
    i8* bitcast (i32 (i8*)* @Element.GetSalary to i8*), 
    i8* bitcast (i1 (i8*)* @Element.GetMarried to i8*), 
    i8* bitcast (i1 (i8*, i8*)* @Element.Equal to i8*), 
    i8* bitcast (i1 (i8*, i32, i32)* @Element.Compare to i8*)
]
@.List_vtable = global [10 x i8*] [
    i8* bitcast (i1 (i8*)* @List.Init to i8*), 
    i8* bitcast (i1 (i8*, i8*, i8*, i1)* @List.InitNew to i8*), 
    i8* bitcast (i8* (i8*, i8*)* @List.Insert to i8*), 
    i8* bitcast (i1 (i8*, i8*)* @List.SetNext to i8*), 
    i8* bitcast (i8* (i8*, i8*)* @List.Delete to i8*), 
    i8* bitcast (i32 (i8*, i8*)* @List.Search to i8*), 
    i8* bitcast (i1 (i8*)* @List.GetEnd to i8*), 
    i8* bitcast (i8* (i8*)* @List.GetElem to i8*), 
    i8* bitcast (i8* (i8*)* @List.GetNext to i8*), 
    i8* bitcast (i1 (i8*)* @List.Print to i8*)
]
define i32 @main() {
    %_0 = call i8* @calloc(i32 1, i32 8)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [1 x i8*], [1 x i8*]* @.LL_vtable, i32 0, i32 0
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

define i1 @Element.Init(i8* %this, i32 %.v_Age, i32 %.v_Salary, i1 %.v_Married) {
    %v_Age = alloca i32
    store i32 %.v_Age, i32* %v_Age ; add the parameter to the stack

    %v_Salary = alloca i32
    store i32 %.v_Salary, i32* %v_Salary ; add the parameter to the stack

    %v_Married = alloca i1
    store i1 %.v_Married, i1* %v_Married ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 8
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %v_Age
    store i32 %_2, i32* %_1
    %_3 = getelementptr i8, i8* %this, i32 12
    %_4 = bitcast i8* %_3 to i32*
    %_5 = load i32, i32* %v_Salary
    store i32 %_5, i32* %_4
    %_6 = getelementptr i8, i8* %this, i32 16
    %_7 = bitcast i8* %_6 to i1*
    %_8 = load i1, i1* %v_Married
    store i1 %_8, i1* %_7
    ret i1 true
}
define i32 @Element.GetAge(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 8
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %_1
    ret i32 %_2
}
define i32 @Element.GetSalary(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 12
    %_1 = bitcast i8* %_0 to i32*
    %_2 = load i32, i32* %_1
    ret i32 %_2
}
define i1 @Element.GetMarried(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %_1
    ret i1 %_2
}
define i1 @Element.Equal(i8* %this, i8* %.other) {
    %other = alloca i8*
    store i8* %.other, i8** %other ; add the parameter to the stack

    %ret_val = alloca i1
    %aux01 = alloca i32
    %aux02 = alloca i32
    %nt = alloca i32
    store i1 true, i1* %ret_val
    %_0 = load i8*, i8** %other
    ; %_0.GetAge : 1
    %_1 = bitcast i8* %_0 to i8***
    %_2 = load i8**, i8*** %_1
    %_3 = getelementptr i8*, i8** %_2, i32 1
    %_4 = load i8*, i8** %_3
    %_5 = bitcast i8* %_4 to i32 (i8*)*
    %_6 = call i32 %_5(i8* %_0)
    store i32 %_6, i32* %aux01
    ; %this.Compare : 5
    %_7 = bitcast i8* %this to i8***
    %_8 = load i8**, i8*** %_7
    %_9 = getelementptr i8*, i8** %_8, i32 5
    %_10 = load i8*, i8** %_9
    %_11 = bitcast i8* %_10 to i1 (i8*, i32, i32)*
    %_12 = load i32, i32* %aux01
    %_13 = getelementptr i8, i8* %this, i32 8
    %_14 = bitcast i8* %_13 to i32*
    %_15 = load i32, i32* %_14
    %_16 = call i1 %_11(i8* %this, i32 %_12, i32 %_15)
    %_17 = icmp eq i1 %_16, false
    br i1 %_17, label %_18, label %_19
_18:
    store i1 false, i1* %ret_val
    br label %_20
_19:
    %_21 = load i8*, i8** %other
    ; %_21.GetSalary : 2
    %_22 = bitcast i8* %_21 to i8***
    %_23 = load i8**, i8*** %_22
    %_24 = getelementptr i8*, i8** %_23, i32 2
    %_25 = load i8*, i8** %_24
    %_26 = bitcast i8* %_25 to i32 (i8*)*
    %_27 = call i32 %_26(i8* %_21)
    store i32 %_27, i32* %aux02
    ; %this.Compare : 5
    %_28 = bitcast i8* %this to i8***
    %_29 = load i8**, i8*** %_28
    %_30 = getelementptr i8*, i8** %_29, i32 5
    %_31 = load i8*, i8** %_30
    %_32 = bitcast i8* %_31 to i1 (i8*, i32, i32)*
    %_33 = load i32, i32* %aux02
    %_34 = getelementptr i8, i8* %this, i32 12
    %_35 = bitcast i8* %_34 to i32*
    %_36 = load i32, i32* %_35
    %_37 = call i1 %_32(i8* %this, i32 %_33, i32 %_36)
    %_38 = icmp eq i1 %_37, false
    br i1 %_38, label %_39, label %_40
_39:
    store i1 false, i1* %ret_val
    br label %_41
_40:
    %_42 = getelementptr i8, i8* %this, i32 16
    %_43 = bitcast i8* %_42 to i1*
    %_44 = load i1, i1* %_43
    br i1 %_44, label %_45, label %_46
_45:
    %_48 = load i8*, i8** %other
    ; %_48.GetMarried : 3
    %_49 = bitcast i8* %_48 to i8***
    %_50 = load i8**, i8*** %_49
    %_51 = getelementptr i8*, i8** %_50, i32 3
    %_52 = load i8*, i8** %_51
    %_53 = bitcast i8* %_52 to i1 (i8*)*
    %_54 = call i1 %_53(i8* %_48)
    %_55 = icmp eq i1 %_54, false
    br i1 %_55, label %_56, label %_57
_56:
    store i1 false, i1* %ret_val
    br label %_58
_57:
    store i32 0, i32* %nt
    br label %_58
_58:
    br label %_47
_46:
    %_59 = load i8*, i8** %other
    ; %_59.GetMarried : 3
    %_60 = bitcast i8* %_59 to i8***
    %_61 = load i8**, i8*** %_60
    %_62 = getelementptr i8*, i8** %_61, i32 3
    %_63 = load i8*, i8** %_62
    %_64 = bitcast i8* %_63 to i1 (i8*)*
    %_65 = call i1 %_64(i8* %_59)
    br i1 %_65, label %_66, label %_67
_66:
    store i1 false, i1* %ret_val
    br label %_68
_67:
    store i32 0, i32* %nt
    br label %_68
_68:
    br label %_47
_47:
    br label %_41
_41:
    br label %_20
_20:
    %_69 = load i1, i1* %ret_val
    ret i1 %_69
}
define i1 @Element.Compare(i8* %this, i32 %.num1, i32 %.num2) {
    %num1 = alloca i32
    store i32 %.num1, i32* %num1 ; add the parameter to the stack

    %num2 = alloca i32
    store i32 %.num2, i32* %num2 ; add the parameter to the stack

    %retval = alloca i1
    %aux02 = alloca i32
    store i1 false, i1* %retval
    %_0 = load i32, i32* %num2
    %_1 = add i32 %_0, 1
    store i32 %_1, i32* %aux02
    %_2 = load i32, i32* %num1
    %_3 = load i32, i32* %num2
    %_4 = icmp slt i32 %_2, %_3
    br i1 %_4, label %_5, label %_6
_5:
    store i1 false, i1* %retval
    br label %_7
_6:
    %_8 = load i32, i32* %num1
    %_9 = load i32, i32* %aux02
    %_10 = icmp slt i32 %_8, %_9
    %_11 = icmp eq i1 %_10, false
    br i1 %_11, label %_12, label %_13
_12:
    store i1 false, i1* %retval
    br label %_14
_13:
    store i1 true, i1* %retval
    br label %_14
_14:
    br label %_7
_7:
    %_15 = load i1, i1* %retval
    ret i1 %_15
}
define i1 @List.Init(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i1*
    store i1 true, i1* %_1
    ret i1 true
}
define i1 @List.InitNew(i8* %this, i8* %.v_elem, i8* %.v_next, i1 %.v_end) {
    %v_elem = alloca i8*
    store i8* %.v_elem, i8** %v_elem ; add the parameter to the stack

    %v_next = alloca i8*
    store i8* %.v_next, i8** %v_next ; add the parameter to the stack

    %v_end = alloca i1
    store i1 %.v_end, i1* %v_end ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %v_end
    store i1 %_2, i1* %_1
    %_3 = getelementptr i8, i8* %this, i32 8
    %_4 = bitcast i8* %_3 to i8**
    %_5 = load i8*, i8** %v_elem
    store i8* %_5, i8** %_4
    %_6 = getelementptr i8, i8* %this, i32 16
    %_7 = bitcast i8* %_6 to i8**
    %_8 = load i8*, i8** %v_next
    store i8* %_8, i8** %_7
    ret i1 true
}
define i8* @List.Insert(i8* %this, i8* %.new_elem) {
    %new_elem = alloca i8*
    store i8* %.new_elem, i8** %new_elem ; add the parameter to the stack

    %ret_val = alloca i1
    %aux03 = alloca i8*
    %aux02 = alloca i8*
    store i8* %this, i8** %aux03
    %_0 = call i8* @calloc(i32 1, i32 25)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [10 x i8*], [10 x i8*]* @.List_vtable, i32 0, i32 0
    store i8** %_2, i8*** %_1
    store i8* %_0, i8** %aux02
    %_3 = load i8*, i8** %aux02
    ; %_3.InitNew : 1
    %_4 = bitcast i8* %_3 to i8***
    %_5 = load i8**, i8*** %_4
    %_6 = getelementptr i8*, i8** %_5, i32 1
    %_7 = load i8*, i8** %_6
    %_8 = bitcast i8* %_7 to i1 (i8*, i8*, i8*, i1)*
    %_9 = load i8*, i8** %new_elem
    %_10 = load i8*, i8** %aux03
    %_11 = call i1 %_8(i8* %_3, i8* %_9, i8* %_10, i1 false)
    store i1 %_11, i1* %ret_val
    %_12 = load i8*, i8** %aux02
    ret i8* %_12
}
define i1 @List.SetNext(i8* %this, i8* %.v_next) {
    %v_next = alloca i8*
    store i8* %.v_next, i8** %v_next ; add the parameter to the stack

    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %v_next
    store i8* %_2, i8** %_1
    ret i1 true
}
define i8* @List.Delete(i8* %this, i8* %.e) {
    %e = alloca i8*
    store i8* %.e, i8** %e ; add the parameter to the stack

    %my_head = alloca i8*
    %ret_val = alloca i1
    %aux05 = alloca i1
    %aux01 = alloca i8*
    %prev = alloca i8*
    %var_end = alloca i1
    %var_elem = alloca i8*
    %aux04 = alloca i32
    %nt = alloca i32
    store i8* %this, i8** %my_head
    store i1 false, i1* %ret_val
    %_0 = sub i32 0, 1
    store i32 %_0, i32* %aux04
    store i8* %this, i8** %aux01
    store i8* %this, i8** %prev
    %_1 = getelementptr i8, i8* %this, i32 24
    %_2 = bitcast i8* %_1 to i1*
    %_3 = load i1, i1* %_2
    store i1 %_3, i1* %var_end
    %_4 = getelementptr i8, i8* %this, i32 8
    %_5 = bitcast i8* %_4 to i8**
    %_6 = load i8*, i8** %_5
    store i8* %_6, i8** %var_elem
    br label %_7
_7:
    br label %_10
_10:
    %_12 = load i1, i1* %var_end
    %_13 = icmp eq i1 %_12, false
    br i1 %_13, label %_14, label %_11
_14:
    %_15 = load i1, i1* %ret_val
    %_16 = icmp eq i1 %_15, false
    br label %_11
_11:
    %_17 = phi i1 [ false, %_10 ], [ %_16, %_14 ]
    br i1 %_17, label %_8, label %_9
_8:
    %_18 = load i8*, i8** %e
    ; %_18.Equal : 4
    %_19 = bitcast i8* %_18 to i8***
    %_20 = load i8**, i8*** %_19
    %_21 = getelementptr i8*, i8** %_20, i32 4
    %_22 = load i8*, i8** %_21
    %_23 = bitcast i8* %_22 to i1 (i8*, i8*)*
    %_24 = load i8*, i8** %var_elem
    %_25 = call i1 %_23(i8* %_18, i8* %_24)
    br i1 %_25, label %_26, label %_27
_26:
    store i1 true, i1* %ret_val
    %_29 = load i32, i32* %aux04
    %_30 = icmp slt i32 %_29, 0
    br i1 %_30, label %_31, label %_32
_31:
    %_34 = load i8*, i8** %aux01
    ; %_34.GetNext : 8
    %_35 = bitcast i8* %_34 to i8***
    %_36 = load i8**, i8*** %_35
    %_37 = getelementptr i8*, i8** %_36, i32 8
    %_38 = load i8*, i8** %_37
    %_39 = bitcast i8* %_38 to i8* (i8*)*
    %_40 = call i8* %_39(i8* %_34)
    store i8* %_40, i8** %my_head
    br label %_33
_32:
    %_41 = sub i32 0, 555
    call void @print_int(i32 %_41) 
    %_42 = load i8*, i8** %prev
    ; %_42.SetNext : 3
    %_43 = bitcast i8* %_42 to i8***
    %_44 = load i8**, i8*** %_43
    %_45 = getelementptr i8*, i8** %_44, i32 3
    %_46 = load i8*, i8** %_45
    %_47 = bitcast i8* %_46 to i1 (i8*, i8*)*
    %_48 = load i8*, i8** %aux01
    ; %_48.GetNext : 8
    %_49 = bitcast i8* %_48 to i8***
    %_50 = load i8**, i8*** %_49
    %_51 = getelementptr i8*, i8** %_50, i32 8
    %_52 = load i8*, i8** %_51
    %_53 = bitcast i8* %_52 to i8* (i8*)*
    %_54 = call i8* %_53(i8* %_48)
    %_55 = call i1 %_47(i8* %_42, i8* %_54)
    store i1 %_55, i1* %aux05
    %_56 = sub i32 0, 555
    call void @print_int(i32 %_56) 
    br label %_33
_33:
    br label %_28
_27:
    store i32 0, i32* %nt
    br label %_28
_28:
    %_57 = load i1, i1* %ret_val
    %_58 = icmp eq i1 %_57, false
    br i1 %_58, label %_59, label %_60
_59:
    %_62 = load i8*, i8** %aux01
    store i8* %_62, i8** %prev
    %_63 = load i8*, i8** %aux01
    ; %_63.GetNext : 8
    %_64 = bitcast i8* %_63 to i8***
    %_65 = load i8**, i8*** %_64
    %_66 = getelementptr i8*, i8** %_65, i32 8
    %_67 = load i8*, i8** %_66
    %_68 = bitcast i8* %_67 to i8* (i8*)*
    %_69 = call i8* %_68(i8* %_63)
    store i8* %_69, i8** %aux01
    %_70 = load i8*, i8** %aux01
    ; %_70.GetEnd : 6
    %_71 = bitcast i8* %_70 to i8***
    %_72 = load i8**, i8*** %_71
    %_73 = getelementptr i8*, i8** %_72, i32 6
    %_74 = load i8*, i8** %_73
    %_75 = bitcast i8* %_74 to i1 (i8*)*
    %_76 = call i1 %_75(i8* %_70)
    store i1 %_76, i1* %var_end
    %_77 = load i8*, i8** %aux01
    ; %_77.GetElem : 7
    %_78 = bitcast i8* %_77 to i8***
    %_79 = load i8**, i8*** %_78
    %_80 = getelementptr i8*, i8** %_79, i32 7
    %_81 = load i8*, i8** %_80
    %_82 = bitcast i8* %_81 to i8* (i8*)*
    %_83 = call i8* %_82(i8* %_77)
    store i8* %_83, i8** %var_elem
    store i32 1, i32* %aux04
    br label %_61
_60:
    store i32 0, i32* %nt
    br label %_61
_61:
    br label %_7
_9:
    %_84 = load i8*, i8** %my_head
    ret i8* %_84
}
define i32 @List.Search(i8* %this, i8* %.e) {
    %e = alloca i8*
    store i8* %.e, i8** %e ; add the parameter to the stack

    %int_ret_val = alloca i32
    %aux01 = alloca i8*
    %var_elem = alloca i8*
    %var_end = alloca i1
    %nt = alloca i32
    store i32 0, i32* %int_ret_val
    store i8* %this, i8** %aux01
    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %_1
    store i1 %_2, i1* %var_end
    %_3 = getelementptr i8, i8* %this, i32 8
    %_4 = bitcast i8* %_3 to i8**
    %_5 = load i8*, i8** %_4
    store i8* %_5, i8** %var_elem
    br label %_6
_6:
    %_9 = load i1, i1* %var_end
    %_10 = icmp eq i1 %_9, false
    br i1 %_10, label %_7, label %_8
_7:
    %_11 = load i8*, i8** %e
    ; %_11.Equal : 4
    %_12 = bitcast i8* %_11 to i8***
    %_13 = load i8**, i8*** %_12
    %_14 = getelementptr i8*, i8** %_13, i32 4
    %_15 = load i8*, i8** %_14
    %_16 = bitcast i8* %_15 to i1 (i8*, i8*)*
    %_17 = load i8*, i8** %var_elem
    %_18 = call i1 %_16(i8* %_11, i8* %_17)
    br i1 %_18, label %_19, label %_20
_19:
    store i32 1, i32* %int_ret_val
    br label %_21
_20:
    store i32 0, i32* %nt
    br label %_21
_21:
    %_22 = load i8*, i8** %aux01
    ; %_22.GetNext : 8
    %_23 = bitcast i8* %_22 to i8***
    %_24 = load i8**, i8*** %_23
    %_25 = getelementptr i8*, i8** %_24, i32 8
    %_26 = load i8*, i8** %_25
    %_27 = bitcast i8* %_26 to i8* (i8*)*
    %_28 = call i8* %_27(i8* %_22)
    store i8* %_28, i8** %aux01
    %_29 = load i8*, i8** %aux01
    ; %_29.GetEnd : 6
    %_30 = bitcast i8* %_29 to i8***
    %_31 = load i8**, i8*** %_30
    %_32 = getelementptr i8*, i8** %_31, i32 6
    %_33 = load i8*, i8** %_32
    %_34 = bitcast i8* %_33 to i1 (i8*)*
    %_35 = call i1 %_34(i8* %_29)
    store i1 %_35, i1* %var_end
    %_36 = load i8*, i8** %aux01
    ; %_36.GetElem : 7
    %_37 = bitcast i8* %_36 to i8***
    %_38 = load i8**, i8*** %_37
    %_39 = getelementptr i8*, i8** %_38, i32 7
    %_40 = load i8*, i8** %_39
    %_41 = bitcast i8* %_40 to i8* (i8*)*
    %_42 = call i8* %_41(i8* %_36)
    store i8* %_42, i8** %var_elem
    br label %_6
_8:
    %_43 = load i32, i32* %int_ret_val
    ret i32 %_43
}
define i1 @List.GetEnd(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %_1
    ret i1 %_2
}
define i8* @List.GetElem(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 8
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %_1
    ret i8* %_2
}
define i8* @List.GetNext(i8* %this) {
    %_0 = getelementptr i8, i8* %this, i32 16
    %_1 = bitcast i8* %_0 to i8**
    %_2 = load i8*, i8** %_1
    ret i8* %_2
}
define i1 @List.Print(i8* %this) {
    %aux01 = alloca i8*
    %var_end = alloca i1
    %var_elem = alloca i8*
    store i8* %this, i8** %aux01
    %_0 = getelementptr i8, i8* %this, i32 24
    %_1 = bitcast i8* %_0 to i1*
    %_2 = load i1, i1* %_1
    store i1 %_2, i1* %var_end
    %_3 = getelementptr i8, i8* %this, i32 8
    %_4 = bitcast i8* %_3 to i8**
    %_5 = load i8*, i8** %_4
    store i8* %_5, i8** %var_elem
    br label %_6
_6:
    %_9 = load i1, i1* %var_end
    %_10 = icmp eq i1 %_9, false
    br i1 %_10, label %_7, label %_8
_7:
    %_11 = load i8*, i8** %var_elem
    ; %_11.GetAge : 1
    %_12 = bitcast i8* %_11 to i8***
    %_13 = load i8**, i8*** %_12
    %_14 = getelementptr i8*, i8** %_13, i32 1
    %_15 = load i8*, i8** %_14
    %_16 = bitcast i8* %_15 to i32 (i8*)*
    %_17 = call i32 %_16(i8* %_11)
    call void @print_int(i32 %_17) 
    %_18 = load i8*, i8** %aux01
    ; %_18.GetNext : 8
    %_19 = bitcast i8* %_18 to i8***
    %_20 = load i8**, i8*** %_19
    %_21 = getelementptr i8*, i8** %_20, i32 8
    %_22 = load i8*, i8** %_21
    %_23 = bitcast i8* %_22 to i8* (i8*)*
    %_24 = call i8* %_23(i8* %_18)
    store i8* %_24, i8** %aux01
    %_25 = load i8*, i8** %aux01
    ; %_25.GetEnd : 6
    %_26 = bitcast i8* %_25 to i8***
    %_27 = load i8**, i8*** %_26
    %_28 = getelementptr i8*, i8** %_27, i32 6
    %_29 = load i8*, i8** %_28
    %_30 = bitcast i8* %_29 to i1 (i8*)*
    %_31 = call i1 %_30(i8* %_25)
    store i1 %_31, i1* %var_end
    %_32 = load i8*, i8** %aux01
    ; %_32.GetElem : 7
    %_33 = bitcast i8* %_32 to i8***
    %_34 = load i8**, i8*** %_33
    %_35 = getelementptr i8*, i8** %_34, i32 7
    %_36 = load i8*, i8** %_35
    %_37 = bitcast i8* %_36 to i8* (i8*)*
    %_38 = call i8* %_37(i8* %_32)
    store i8* %_38, i8** %var_elem
    br label %_6
_8:
    ret i1 true
}
define i32 @LL.Start(i8* %this) {
    %head = alloca i8*
    %last_elem = alloca i8*
    %aux01 = alloca i1
    %el01 = alloca i8*
    %el02 = alloca i8*
    %el03 = alloca i8*
    %_0 = call i8* @calloc(i32 1, i32 25)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [10 x i8*], [10 x i8*]* @.List_vtable, i32 0, i32 0
    store i8** %_2, i8*** %_1
    store i8* %_0, i8** %last_elem
    %_3 = load i8*, i8** %last_elem
    ; %_3.Init : 0
    %_4 = bitcast i8* %_3 to i8***
    %_5 = load i8**, i8*** %_4
    %_6 = getelementptr i8*, i8** %_5, i32 0
    %_7 = load i8*, i8** %_6
    %_8 = bitcast i8* %_7 to i1 (i8*)*
    %_9 = call i1 %_8(i8* %_3)
    store i1 %_9, i1* %aux01
    %_10 = load i8*, i8** %last_elem
    store i8* %_10, i8** %head
    %_11 = load i8*, i8** %head
    ; %_11.Init : 0
    %_12 = bitcast i8* %_11 to i8***
    %_13 = load i8**, i8*** %_12
    %_14 = getelementptr i8*, i8** %_13, i32 0
    %_15 = load i8*, i8** %_14
    %_16 = bitcast i8* %_15 to i1 (i8*)*
    %_17 = call i1 %_16(i8* %_11)
    store i1 %_17, i1* %aux01
    %_18 = load i8*, i8** %head
    ; %_18.Print : 9
    %_19 = bitcast i8* %_18 to i8***
    %_20 = load i8**, i8*** %_19
    %_21 = getelementptr i8*, i8** %_20, i32 9
    %_22 = load i8*, i8** %_21
    %_23 = bitcast i8* %_22 to i1 (i8*)*
    %_24 = call i1 %_23(i8* %_18)
    store i1 %_24, i1* %aux01
    %_25 = call i8* @calloc(i32 1, i32 17)
    %_26 = bitcast i8* %_25 to i8***
    %_27 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
    store i8** %_27, i8*** %_26
    store i8* %_25, i8** %el01
    %_28 = load i8*, i8** %el01
    ; %_28.Init : 0
    %_29 = bitcast i8* %_28 to i8***
    %_30 = load i8**, i8*** %_29
    %_31 = getelementptr i8*, i8** %_30, i32 0
    %_32 = load i8*, i8** %_31
    %_33 = bitcast i8* %_32 to i1 (i8*, i32, i32, i1)*
    %_34 = call i1 %_33(i8* %_28, i32 25, i32 37000, i1 false)
    store i1 %_34, i1* %aux01
    %_35 = load i8*, i8** %head
    ; %_35.Insert : 2
    %_36 = bitcast i8* %_35 to i8***
    %_37 = load i8**, i8*** %_36
    %_38 = getelementptr i8*, i8** %_37, i32 2
    %_39 = load i8*, i8** %_38
    %_40 = bitcast i8* %_39 to i8* (i8*, i8*)*
    %_41 = load i8*, i8** %el01
    %_42 = call i8* %_40(i8* %_35, i8* %_41)
    store i8* %_42, i8** %head
    %_43 = load i8*, i8** %head
    ; %_43.Print : 9
    %_44 = bitcast i8* %_43 to i8***
    %_45 = load i8**, i8*** %_44
    %_46 = getelementptr i8*, i8** %_45, i32 9
    %_47 = load i8*, i8** %_46
    %_48 = bitcast i8* %_47 to i1 (i8*)*
    %_49 = call i1 %_48(i8* %_43)
    store i1 %_49, i1* %aux01
    call void @print_int(i32 10000000) 
    %_50 = call i8* @calloc(i32 1, i32 17)
    %_51 = bitcast i8* %_50 to i8***
    %_52 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
    store i8** %_52, i8*** %_51
    store i8* %_50, i8** %el01
    %_53 = load i8*, i8** %el01
    ; %_53.Init : 0
    %_54 = bitcast i8* %_53 to i8***
    %_55 = load i8**, i8*** %_54
    %_56 = getelementptr i8*, i8** %_55, i32 0
    %_57 = load i8*, i8** %_56
    %_58 = bitcast i8* %_57 to i1 (i8*, i32, i32, i1)*
    %_59 = call i1 %_58(i8* %_53, i32 39, i32 42000, i1 true)
    store i1 %_59, i1* %aux01
    %_60 = load i8*, i8** %el01
    store i8* %_60, i8** %el02
    %_61 = load i8*, i8** %head
    ; %_61.Insert : 2
    %_62 = bitcast i8* %_61 to i8***
    %_63 = load i8**, i8*** %_62
    %_64 = getelementptr i8*, i8** %_63, i32 2
    %_65 = load i8*, i8** %_64
    %_66 = bitcast i8* %_65 to i8* (i8*, i8*)*
    %_67 = load i8*, i8** %el01
    %_68 = call i8* %_66(i8* %_61, i8* %_67)
    store i8* %_68, i8** %head
    %_69 = load i8*, i8** %head
    ; %_69.Print : 9
    %_70 = bitcast i8* %_69 to i8***
    %_71 = load i8**, i8*** %_70
    %_72 = getelementptr i8*, i8** %_71, i32 9
    %_73 = load i8*, i8** %_72
    %_74 = bitcast i8* %_73 to i1 (i8*)*
    %_75 = call i1 %_74(i8* %_69)
    store i1 %_75, i1* %aux01
    call void @print_int(i32 10000000) 
    %_76 = call i8* @calloc(i32 1, i32 17)
    %_77 = bitcast i8* %_76 to i8***
    %_78 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
    store i8** %_78, i8*** %_77
    store i8* %_76, i8** %el01
    %_79 = load i8*, i8** %el01
    ; %_79.Init : 0
    %_80 = bitcast i8* %_79 to i8***
    %_81 = load i8**, i8*** %_80
    %_82 = getelementptr i8*, i8** %_81, i32 0
    %_83 = load i8*, i8** %_82
    %_84 = bitcast i8* %_83 to i1 (i8*, i32, i32, i1)*
    %_85 = call i1 %_84(i8* %_79, i32 22, i32 34000, i1 false)
    store i1 %_85, i1* %aux01
    %_86 = load i8*, i8** %head
    ; %_86.Insert : 2
    %_87 = bitcast i8* %_86 to i8***
    %_88 = load i8**, i8*** %_87
    %_89 = getelementptr i8*, i8** %_88, i32 2
    %_90 = load i8*, i8** %_89
    %_91 = bitcast i8* %_90 to i8* (i8*, i8*)*
    %_92 = load i8*, i8** %el01
    %_93 = call i8* %_91(i8* %_86, i8* %_92)
    store i8* %_93, i8** %head
    %_94 = load i8*, i8** %head
    ; %_94.Print : 9
    %_95 = bitcast i8* %_94 to i8***
    %_96 = load i8**, i8*** %_95
    %_97 = getelementptr i8*, i8** %_96, i32 9
    %_98 = load i8*, i8** %_97
    %_99 = bitcast i8* %_98 to i1 (i8*)*
    %_100 = call i1 %_99(i8* %_94)
    store i1 %_100, i1* %aux01
    %_101 = call i8* @calloc(i32 1, i32 17)
    %_102 = bitcast i8* %_101 to i8***
    %_103 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
    store i8** %_103, i8*** %_102
    store i8* %_101, i8** %el03
    %_104 = load i8*, i8** %el03
    ; %_104.Init : 0
    %_105 = bitcast i8* %_104 to i8***
    %_106 = load i8**, i8*** %_105
    %_107 = getelementptr i8*, i8** %_106, i32 0
    %_108 = load i8*, i8** %_107
    %_109 = bitcast i8* %_108 to i1 (i8*, i32, i32, i1)*
    %_110 = call i1 %_109(i8* %_104, i32 27, i32 34000, i1 false)
    store i1 %_110, i1* %aux01
    %_111 = load i8*, i8** %head
    ; %_111.Search : 5
    %_112 = bitcast i8* %_111 to i8***
    %_113 = load i8**, i8*** %_112
    %_114 = getelementptr i8*, i8** %_113, i32 5
    %_115 = load i8*, i8** %_114
    %_116 = bitcast i8* %_115 to i32 (i8*, i8*)*
    %_117 = load i8*, i8** %el02
    %_118 = call i32 %_116(i8* %_111, i8* %_117)
    call void @print_int(i32 %_118) 
    %_119 = load i8*, i8** %head
    ; %_119.Search : 5
    %_120 = bitcast i8* %_119 to i8***
    %_121 = load i8**, i8*** %_120
    %_122 = getelementptr i8*, i8** %_121, i32 5
    %_123 = load i8*, i8** %_122
    %_124 = bitcast i8* %_123 to i32 (i8*, i8*)*
    %_125 = load i8*, i8** %el03
    %_126 = call i32 %_124(i8* %_119, i8* %_125)
    call void @print_int(i32 %_126) 
    call void @print_int(i32 10000000) 
    %_127 = call i8* @calloc(i32 1, i32 17)
    %_128 = bitcast i8* %_127 to i8***
    %_129 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
    store i8** %_129, i8*** %_128
    store i8* %_127, i8** %el01
    %_130 = load i8*, i8** %el01
    ; %_130.Init : 0
    %_131 = bitcast i8* %_130 to i8***
    %_132 = load i8**, i8*** %_131
    %_133 = getelementptr i8*, i8** %_132, i32 0
    %_134 = load i8*, i8** %_133
    %_135 = bitcast i8* %_134 to i1 (i8*, i32, i32, i1)*
    %_136 = call i1 %_135(i8* %_130, i32 28, i32 35000, i1 false)
    store i1 %_136, i1* %aux01
    %_137 = load i8*, i8** %head
    ; %_137.Insert : 2
    %_138 = bitcast i8* %_137 to i8***
    %_139 = load i8**, i8*** %_138
    %_140 = getelementptr i8*, i8** %_139, i32 2
    %_141 = load i8*, i8** %_140
    %_142 = bitcast i8* %_141 to i8* (i8*, i8*)*
    %_143 = load i8*, i8** %el01
    %_144 = call i8* %_142(i8* %_137, i8* %_143)
    store i8* %_144, i8** %head
    %_145 = load i8*, i8** %head
    ; %_145.Print : 9
    %_146 = bitcast i8* %_145 to i8***
    %_147 = load i8**, i8*** %_146
    %_148 = getelementptr i8*, i8** %_147, i32 9
    %_149 = load i8*, i8** %_148
    %_150 = bitcast i8* %_149 to i1 (i8*)*
    %_151 = call i1 %_150(i8* %_145)
    store i1 %_151, i1* %aux01
    call void @print_int(i32 2220000) 
    %_152 = load i8*, i8** %head
    ; %_152.Delete : 4
    %_153 = bitcast i8* %_152 to i8***
    %_154 = load i8**, i8*** %_153
    %_155 = getelementptr i8*, i8** %_154, i32 4
    %_156 = load i8*, i8** %_155
    %_157 = bitcast i8* %_156 to i8* (i8*, i8*)*
    %_158 = load i8*, i8** %el02
    %_159 = call i8* %_157(i8* %_152, i8* %_158)
    store i8* %_159, i8** %head
    %_160 = load i8*, i8** %head
    ; %_160.Print : 9
    %_161 = bitcast i8* %_160 to i8***
    %_162 = load i8**, i8*** %_161
    %_163 = getelementptr i8*, i8** %_162, i32 9
    %_164 = load i8*, i8** %_163
    %_165 = bitcast i8* %_164 to i1 (i8*)*
    %_166 = call i1 %_165(i8* %_160)
    store i1 %_166, i1* %aux01
    call void @print_int(i32 33300000) 
    %_167 = load i8*, i8** %head
    ; %_167.Delete : 4
    %_168 = bitcast i8* %_167 to i8***
    %_169 = load i8**, i8*** %_168
    %_170 = getelementptr i8*, i8** %_169, i32 4
    %_171 = load i8*, i8** %_170
    %_172 = bitcast i8* %_171 to i8* (i8*, i8*)*
    %_173 = load i8*, i8** %el01
    %_174 = call i8* %_172(i8* %_167, i8* %_173)
    store i8* %_174, i8** %head
    %_175 = load i8*, i8** %head
    ; %_175.Print : 9
    %_176 = bitcast i8* %_175 to i8***
    %_177 = load i8**, i8*** %_176
    %_178 = getelementptr i8*, i8** %_177, i32 9
    %_179 = load i8*, i8** %_178
    %_180 = bitcast i8* %_179 to i1 (i8*)*
    %_181 = call i1 %_180(i8* %_175)
    store i1 %_181, i1* %aux01
    call void @print_int(i32 44440000) 
    ret i32 0
}
