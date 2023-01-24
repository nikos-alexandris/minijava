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

@.QS_vtable = global [4 x i8*] [
    i8* bitcast (i32 (i8*, i32)* @QS.Start to i8*), 
    i8* bitcast (i32 (i8*, i32, i32)* @QS.Sort to i8*), 
    i8* bitcast (i32 (i8*)* @QS.Print to i8*), 
    i8* bitcast (i32 (i8*, i32)* @QS.Init to i8*)
]
define i32 @main() {
    %_0 = call i8* @calloc(i32 1, i32 20)
    %_1 = bitcast i8* %_0 to i8***
    %_2 = getelementptr [4 x i8*], [4 x i8*]* @.QS_vtable, i32 0, i32 0
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

define i32 @QS.Start(i8* %this, i32 %.sz) {
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
    call void @print_int(i32 9999) 
    %_13 = getelementptr i8, i8* %this, i32 16
    %_14 = bitcast i8* %_13 to i32*
    %_15 = load i32, i32* %_14
    %_16 = sub i32 %_15, 1
    store i32 %_16, i32* %aux01
    ; %this.Sort : 1
    %_17 = bitcast i8* %this to i8***
    %_18 = load i8**, i8*** %_17
    %_19 = getelementptr i8*, i8** %_18, i32 1
    %_20 = load i8*, i8** %_19
    %_21 = bitcast i8* %_20 to i32 (i8*, i32, i32)*
    %_22 = load i32, i32* %aux01
    %_23 = call i32 %_21(i8* %this, i32 0, i32 %_22)
    store i32 %_23, i32* %aux01
    ; %this.Print : 2
    %_24 = bitcast i8* %this to i8***
    %_25 = load i8**, i8*** %_24
    %_26 = getelementptr i8*, i8** %_25, i32 2
    %_27 = load i8*, i8** %_26
    %_28 = bitcast i8* %_27 to i32 (i8*)*
    %_29 = call i32 %_28(i8* %this)
    store i32 %_29, i32* %aux01
    ret i32 0
}
define i32 @QS.Sort(i8* %this, i32 %.left, i32 %.right) {
    %left = alloca i32
    store i32 %.left, i32* %left ; add the parameter to the stack

    %right = alloca i32
    store i32 %.right, i32* %right ; add the parameter to the stack

    %v = alloca i32
    %i = alloca i32
    %j = alloca i32
    %nt = alloca i32
    %t = alloca i32
    %cont01 = alloca i1
    %cont02 = alloca i1
    %aux03 = alloca i32
    store i32 0, i32* %t
    %_0 = load i32, i32* %left
    %_1 = load i32, i32* %right
    %_2 = icmp slt i32 %_0, %_1
    br i1 %_2, label %_3, label %_4
_3:
    %_6 = getelementptr i8, i8* %this, i32 8
    %_7 = bitcast i8* %_6 to %"i32[]"**
    %_8 = load %"i32[]"*, %"i32[]"** %_7
    %_9 = load i32, i32* %right
    %_10 = icmp slt i32 %_9, 0 ; test if index is < 0
    br i1 %_10, label %_11, label %_12
_11:
    call void @throw_oob()
    unreachable
_12:
    %_13 = getelementptr %"i32[]", %"i32[]"* %_8, i32 0, i32 0 ; get pointer to len
    %_14 = load i32, i32* %_13 ; load len
    %_17 = icmp ult i32 %_9, %_14 ; test if index is < len
    br i1 %_17, label %_16, label %_15
_15:
    call void @throw_oob()
    unreachable
_16:
    %_18 = getelementptr %"i32[]", %"i32[]"* %_8, i32 0, i32 1 ; get pointer to array
    %_19  = getelementptr [0 x i32], [0 x i32]* %_18, i32 0, i32 %_9 ; get pointer to value
    %_20 = load i32, i32* %_19 ; load result
    store i32 %_20, i32* %v
    %_21 = load i32, i32* %left
    %_22 = sub i32 %_21, 1
    store i32 %_22, i32* %i
    %_23 = load i32, i32* %right
    store i32 %_23, i32* %j
    store i1 true, i1* %cont01
    br label %_24
_24:
    %_27 = load i1, i1* %cont01
    br i1 %_27, label %_25, label %_26
_25:
    store i1 true, i1* %cont02
    br label %_28
_28:
    %_31 = load i1, i1* %cont02
    br i1 %_31, label %_29, label %_30
_29:
    %_32 = load i32, i32* %i
    %_33 = add i32 %_32, 1
    store i32 %_33, i32* %i
    %_34 = getelementptr i8, i8* %this, i32 8
    %_35 = bitcast i8* %_34 to %"i32[]"**
    %_36 = load %"i32[]"*, %"i32[]"** %_35
    %_37 = load i32, i32* %i
    %_38 = icmp slt i32 %_37, 0 ; test if index is < 0
    br i1 %_38, label %_39, label %_40
_39:
    call void @throw_oob()
    unreachable
_40:
    %_41 = getelementptr %"i32[]", %"i32[]"* %_36, i32 0, i32 0 ; get pointer to len
    %_42 = load i32, i32* %_41 ; load len
    %_45 = icmp ult i32 %_37, %_42 ; test if index is < len
    br i1 %_45, label %_44, label %_43
_43:
    call void @throw_oob()
    unreachable
_44:
    %_46 = getelementptr %"i32[]", %"i32[]"* %_36, i32 0, i32 1 ; get pointer to array
    %_47  = getelementptr [0 x i32], [0 x i32]* %_46, i32 0, i32 %_37 ; get pointer to value
    %_48 = load i32, i32* %_47 ; load result
    store i32 %_48, i32* %aux03
    %_49 = load i32, i32* %aux03
    %_50 = load i32, i32* %v
    %_51 = icmp slt i32 %_49, %_50
    %_52 = icmp eq i1 %_51, false
    br i1 %_52, label %_53, label %_54
_53:
    store i1 false, i1* %cont02
    br label %_55
_54:
    store i1 true, i1* %cont02
    br label %_55
_55:
    br label %_28
_30:
    store i1 true, i1* %cont02
    br label %_56
_56:
    %_59 = load i1, i1* %cont02
    br i1 %_59, label %_57, label %_58
_57:
    %_60 = load i32, i32* %j
    %_61 = sub i32 %_60, 1
    store i32 %_61, i32* %j
    %_62 = getelementptr i8, i8* %this, i32 8
    %_63 = bitcast i8* %_62 to %"i32[]"**
    %_64 = load %"i32[]"*, %"i32[]"** %_63
    %_65 = load i32, i32* %j
    %_66 = icmp slt i32 %_65, 0 ; test if index is < 0
    br i1 %_66, label %_67, label %_68
_67:
    call void @throw_oob()
    unreachable
_68:
    %_69 = getelementptr %"i32[]", %"i32[]"* %_64, i32 0, i32 0 ; get pointer to len
    %_70 = load i32, i32* %_69 ; load len
    %_73 = icmp ult i32 %_65, %_70 ; test if index is < len
    br i1 %_73, label %_72, label %_71
_71:
    call void @throw_oob()
    unreachable
_72:
    %_74 = getelementptr %"i32[]", %"i32[]"* %_64, i32 0, i32 1 ; get pointer to array
    %_75  = getelementptr [0 x i32], [0 x i32]* %_74, i32 0, i32 %_65 ; get pointer to value
    %_76 = load i32, i32* %_75 ; load result
    store i32 %_76, i32* %aux03
    %_77 = load i32, i32* %v
    %_78 = load i32, i32* %aux03
    %_79 = icmp slt i32 %_77, %_78
    %_80 = icmp eq i1 %_79, false
    br i1 %_80, label %_81, label %_82
_81:
    store i1 false, i1* %cont02
    br label %_83
_82:
    store i1 true, i1* %cont02
    br label %_83
_83:
    br label %_56
_58:
    %_84 = getelementptr i8, i8* %this, i32 8
    %_85 = bitcast i8* %_84 to %"i32[]"**
    %_86 = load %"i32[]"*, %"i32[]"** %_85
    %_87 = load i32, i32* %i
    %_88 = icmp slt i32 %_87, 0 ; test if index is < 0
    br i1 %_88, label %_89, label %_90
_89:
    call void @throw_oob()
    unreachable
_90:
    %_91 = getelementptr %"i32[]", %"i32[]"* %_86, i32 0, i32 0 ; get pointer to len
    %_92 = load i32, i32* %_91 ; load len
    %_95 = icmp ult i32 %_87, %_92 ; test if index is < len
    br i1 %_95, label %_94, label %_93
_93:
    call void @throw_oob()
    unreachable
_94:
    %_96 = getelementptr %"i32[]", %"i32[]"* %_86, i32 0, i32 1 ; get pointer to array
    %_97  = getelementptr [0 x i32], [0 x i32]* %_96, i32 0, i32 %_87 ; get pointer to value
    %_98 = load i32, i32* %_97 ; load result
    store i32 %_98, i32* %t
    %_99 = getelementptr i8, i8* %this, i32 8
    %_100 = bitcast i8* %_99 to %"i32[]"**
    %_101 = load %"i32[]"*, %"i32[]"** %_100
    %_102 = load i32, i32* %i
    %_103 = icmp slt i32 %_102, 0 ; test if index is < 0
    br i1 %_103, label %_104, label %_105
_104:
    call void @throw_oob()
    unreachable
_105:
    %_106 = getelementptr i8, i8* %this, i32 8
    %_107 = bitcast i8* %_106 to %"i32[]"**
    %_108 = load %"i32[]"*, %"i32[]"** %_107
    %_109 = load i32, i32* %j
    %_110 = icmp slt i32 %_109, 0 ; test if index is < 0
    br i1 %_110, label %_111, label %_112
_111:
    call void @throw_oob()
    unreachable
_112:
    %_113 = getelementptr %"i32[]", %"i32[]"* %_108, i32 0, i32 0 ; get pointer to len
    %_114 = load i32, i32* %_113 ; load len
    %_117 = icmp ult i32 %_109, %_114 ; test if index is < len
    br i1 %_117, label %_116, label %_115
_115:
    call void @throw_oob()
    unreachable
_116:
    %_118 = getelementptr %"i32[]", %"i32[]"* %_108, i32 0, i32 1 ; get pointer to array
    %_119  = getelementptr [0 x i32], [0 x i32]* %_118, i32 0, i32 %_109 ; get pointer to value
    %_120 = load i32, i32* %_119 ; load result
    %_121 = getelementptr %"i32[]", %"i32[]"* %_101, i32 0, i32 0 ; get pointer to len
    %_122 = load i32, i32* %_121 ; load array length
    %_125 = icmp ult i32 %_102, %_122 ; test if index is < len
    br i1 %_125, label %_124, label %_123
_123:
    call void @throw_oob()
    unreachable
_124:
    %_126 = getelementptr %"i32[]", %"i32[]"* %_101, i32 0, i32 1 ; get pointer to array
    %_127  = getelementptr [0 x i32], [0 x i32]* %_126, i32 0, i32 %_102 ; get pointer to value
    store i32 %_120, i32* %_127
    %_128 = getelementptr i8, i8* %this, i32 8
    %_129 = bitcast i8* %_128 to %"i32[]"**
    %_130 = load %"i32[]"*, %"i32[]"** %_129
    %_131 = load i32, i32* %j
    %_132 = icmp slt i32 %_131, 0 ; test if index is < 0
    br i1 %_132, label %_133, label %_134
_133:
    call void @throw_oob()
    unreachable
_134:
    %_135 = load i32, i32* %t
    %_136 = getelementptr %"i32[]", %"i32[]"* %_130, i32 0, i32 0 ; get pointer to len
    %_137 = load i32, i32* %_136 ; load array length
    %_140 = icmp ult i32 %_131, %_137 ; test if index is < len
    br i1 %_140, label %_139, label %_138
_138:
    call void @throw_oob()
    unreachable
_139:
    %_141 = getelementptr %"i32[]", %"i32[]"* %_130, i32 0, i32 1 ; get pointer to array
    %_142  = getelementptr [0 x i32], [0 x i32]* %_141, i32 0, i32 %_131 ; get pointer to value
    store i32 %_135, i32* %_142
    %_143 = load i32, i32* %j
    %_144 = load i32, i32* %i
    %_145 = add i32 %_144, 1
    %_146 = icmp slt i32 %_143, %_145
    br i1 %_146, label %_147, label %_148
_147:
    store i1 false, i1* %cont01
    br label %_149
_148:
    store i1 true, i1* %cont01
    br label %_149
_149:
    br label %_24
_26:
    %_150 = getelementptr i8, i8* %this, i32 8
    %_151 = bitcast i8* %_150 to %"i32[]"**
    %_152 = load %"i32[]"*, %"i32[]"** %_151
    %_153 = load i32, i32* %j
    %_154 = icmp slt i32 %_153, 0 ; test if index is < 0
    br i1 %_154, label %_155, label %_156
_155:
    call void @throw_oob()
    unreachable
_156:
    %_157 = getelementptr i8, i8* %this, i32 8
    %_158 = bitcast i8* %_157 to %"i32[]"**
    %_159 = load %"i32[]"*, %"i32[]"** %_158
    %_160 = load i32, i32* %i
    %_161 = icmp slt i32 %_160, 0 ; test if index is < 0
    br i1 %_161, label %_162, label %_163
_162:
    call void @throw_oob()
    unreachable
_163:
    %_164 = getelementptr %"i32[]", %"i32[]"* %_159, i32 0, i32 0 ; get pointer to len
    %_165 = load i32, i32* %_164 ; load len
    %_168 = icmp ult i32 %_160, %_165 ; test if index is < len
    br i1 %_168, label %_167, label %_166
_166:
    call void @throw_oob()
    unreachable
_167:
    %_169 = getelementptr %"i32[]", %"i32[]"* %_159, i32 0, i32 1 ; get pointer to array
    %_170  = getelementptr [0 x i32], [0 x i32]* %_169, i32 0, i32 %_160 ; get pointer to value
    %_171 = load i32, i32* %_170 ; load result
    %_172 = getelementptr %"i32[]", %"i32[]"* %_152, i32 0, i32 0 ; get pointer to len
    %_173 = load i32, i32* %_172 ; load array length
    %_176 = icmp ult i32 %_153, %_173 ; test if index is < len
    br i1 %_176, label %_175, label %_174
_174:
    call void @throw_oob()
    unreachable
_175:
    %_177 = getelementptr %"i32[]", %"i32[]"* %_152, i32 0, i32 1 ; get pointer to array
    %_178  = getelementptr [0 x i32], [0 x i32]* %_177, i32 0, i32 %_153 ; get pointer to value
    store i32 %_171, i32* %_178
    %_179 = getelementptr i8, i8* %this, i32 8
    %_180 = bitcast i8* %_179 to %"i32[]"**
    %_181 = load %"i32[]"*, %"i32[]"** %_180
    %_182 = load i32, i32* %i
    %_183 = icmp slt i32 %_182, 0 ; test if index is < 0
    br i1 %_183, label %_184, label %_185
_184:
    call void @throw_oob()
    unreachable
_185:
    %_186 = getelementptr i8, i8* %this, i32 8
    %_187 = bitcast i8* %_186 to %"i32[]"**
    %_188 = load %"i32[]"*, %"i32[]"** %_187
    %_189 = load i32, i32* %right
    %_190 = icmp slt i32 %_189, 0 ; test if index is < 0
    br i1 %_190, label %_191, label %_192
_191:
    call void @throw_oob()
    unreachable
_192:
    %_193 = getelementptr %"i32[]", %"i32[]"* %_188, i32 0, i32 0 ; get pointer to len
    %_194 = load i32, i32* %_193 ; load len
    %_197 = icmp ult i32 %_189, %_194 ; test if index is < len
    br i1 %_197, label %_196, label %_195
_195:
    call void @throw_oob()
    unreachable
_196:
    %_198 = getelementptr %"i32[]", %"i32[]"* %_188, i32 0, i32 1 ; get pointer to array
    %_199  = getelementptr [0 x i32], [0 x i32]* %_198, i32 0, i32 %_189 ; get pointer to value
    %_200 = load i32, i32* %_199 ; load result
    %_201 = getelementptr %"i32[]", %"i32[]"* %_181, i32 0, i32 0 ; get pointer to len
    %_202 = load i32, i32* %_201 ; load array length
    %_205 = icmp ult i32 %_182, %_202 ; test if index is < len
    br i1 %_205, label %_204, label %_203
_203:
    call void @throw_oob()
    unreachable
_204:
    %_206 = getelementptr %"i32[]", %"i32[]"* %_181, i32 0, i32 1 ; get pointer to array
    %_207  = getelementptr [0 x i32], [0 x i32]* %_206, i32 0, i32 %_182 ; get pointer to value
    store i32 %_200, i32* %_207
    %_208 = getelementptr i8, i8* %this, i32 8
    %_209 = bitcast i8* %_208 to %"i32[]"**
    %_210 = load %"i32[]"*, %"i32[]"** %_209
    %_211 = load i32, i32* %right
    %_212 = icmp slt i32 %_211, 0 ; test if index is < 0
    br i1 %_212, label %_213, label %_214
_213:
    call void @throw_oob()
    unreachable
_214:
    %_215 = load i32, i32* %t
    %_216 = getelementptr %"i32[]", %"i32[]"* %_210, i32 0, i32 0 ; get pointer to len
    %_217 = load i32, i32* %_216 ; load array length
    %_220 = icmp ult i32 %_211, %_217 ; test if index is < len
    br i1 %_220, label %_219, label %_218
_218:
    call void @throw_oob()
    unreachable
_219:
    %_221 = getelementptr %"i32[]", %"i32[]"* %_210, i32 0, i32 1 ; get pointer to array
    %_222  = getelementptr [0 x i32], [0 x i32]* %_221, i32 0, i32 %_211 ; get pointer to value
    store i32 %_215, i32* %_222
    ; %this.Sort : 1
    %_223 = bitcast i8* %this to i8***
    %_224 = load i8**, i8*** %_223
    %_225 = getelementptr i8*, i8** %_224, i32 1
    %_226 = load i8*, i8** %_225
    %_227 = bitcast i8* %_226 to i32 (i8*, i32, i32)*
    %_228 = load i32, i32* %left
    %_229 = load i32, i32* %i
    %_230 = sub i32 %_229, 1
    %_231 = call i32 %_227(i8* %this, i32 %_228, i32 %_230)
    store i32 %_231, i32* %nt
    ; %this.Sort : 1
    %_232 = bitcast i8* %this to i8***
    %_233 = load i8**, i8*** %_232
    %_234 = getelementptr i8*, i8** %_233, i32 1
    %_235 = load i8*, i8** %_234
    %_236 = bitcast i8* %_235 to i32 (i8*, i32, i32)*
    %_237 = load i32, i32* %i
    %_238 = add i32 %_237, 1
    %_239 = load i32, i32* %right
    %_240 = call i32 %_236(i8* %this, i32 %_238, i32 %_239)
    store i32 %_240, i32* %nt
    br label %_5
_4:
    store i32 0, i32* %nt
    br label %_5
_5:
    ret i32 0
}
define i32 @QS.Print(i8* %this) {
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
define i32 @QS.Init(i8* %this, i32 %.sz) {
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
