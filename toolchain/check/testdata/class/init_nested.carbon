// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/init_nested.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/init_nested.carbon

class Inner {
  var a: i32;
  var b: i32;
}

fn MakeInner() -> Inner;

class Outer {
  var c: Inner;
  var d: Inner;
}

fn MakeOuter() -> Outer {
  return {.c = MakeInner(), .d = MakeInner()};
}

// CHECK:STDOUT: --- init_nested.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Inner: type = class_type @Inner [template]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %Inner.elem: type = unbound_element_type %Inner, %i32 [template]
// CHECK:STDOUT:   %struct_type.a.b: type = struct_type {.a: %i32, .b: %i32} [template]
// CHECK:STDOUT:   %complete_type.3: <witness> = complete_type_witness %struct_type.a.b [template]
// CHECK:STDOUT:   %MakeInner.type: type = fn_type @MakeInner [template]
// CHECK:STDOUT:   %MakeInner: %MakeInner.type = struct_value () [template]
// CHECK:STDOUT:   %Outer: type = class_type @Outer [template]
// CHECK:STDOUT:   %Outer.elem: type = unbound_element_type %Outer, %Inner [template]
// CHECK:STDOUT:   %struct_type.c.d.1: type = struct_type {.c: %Inner, .d: %Inner} [template]
// CHECK:STDOUT:   %complete_type.4: <witness> = complete_type_witness %struct_type.c.d.1 [template]
// CHECK:STDOUT:   %MakeOuter.type: type = fn_type @MakeOuter [template]
// CHECK:STDOUT:   %MakeOuter: %MakeOuter.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.1
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Inner = %Inner.decl
// CHECK:STDOUT:     .MakeInner = %MakeInner.decl
// CHECK:STDOUT:     .Outer = %Outer.decl
// CHECK:STDOUT:     .MakeOuter = %MakeOuter.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Inner.decl: type = class_decl @Inner [template = constants.%Inner] {} {}
// CHECK:STDOUT:   %MakeInner.decl: %MakeInner.type = fn_decl @MakeInner [template = constants.%MakeInner] {
// CHECK:STDOUT:     %return.patt: %Inner = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %Inner = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %Inner.ref: type = name_ref Inner, file.%Inner.decl [template = constants.%Inner]
// CHECK:STDOUT:     %return.param: ref %Inner = out_param runtime_param0
// CHECK:STDOUT:     %return: ref %Inner = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Outer.decl: type = class_decl @Outer [template = constants.%Outer] {} {}
// CHECK:STDOUT:   %MakeOuter.decl: %MakeOuter.type = fn_decl @MakeOuter [template = constants.%MakeOuter] {
// CHECK:STDOUT:     %return.patt: %Outer = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %Outer = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %Outer.ref: type = name_ref Outer, file.%Outer.decl [template = constants.%Outer]
// CHECK:STDOUT:     %return.param: ref %Outer = out_param runtime_param0
// CHECK:STDOUT:     %return: ref %Outer = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Inner {
// CHECK:STDOUT:   %.loc12: %Inner.elem = field_decl a, element0 [template]
// CHECK:STDOUT:   %.loc13: %Inner.elem = field_decl b, element1 [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %struct_type.a.b [template = constants.%complete_type.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Inner
// CHECK:STDOUT:   .a = %.loc12
// CHECK:STDOUT:   .b = %.loc13
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Outer {
// CHECK:STDOUT:   %.loc19: %Outer.elem = field_decl c, element0 [template]
// CHECK:STDOUT:   %.loc20: %Outer.elem = field_decl d, element1 [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %struct_type.c.d.1 [template = constants.%complete_type.4]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Outer
// CHECK:STDOUT:   .c = %.loc19
// CHECK:STDOUT:   .d = %.loc20
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @MakeInner() -> %Inner;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @MakeOuter() -> %return.param_patt: %Outer {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %MakeInner.ref.loc24_16: %MakeInner.type = name_ref MakeInner, file.%MakeInner.decl [template = constants.%MakeInner]
// CHECK:STDOUT:   %.loc24_45.1: ref %Inner = class_element_access %return, element0
// CHECK:STDOUT:   %MakeInner.call.loc24_26: init %Inner = call %MakeInner.ref.loc24_16() to %.loc24_45.1
// CHECK:STDOUT:   %MakeInner.ref.loc24_34: %MakeInner.type = name_ref MakeInner, file.%MakeInner.decl [template = constants.%MakeInner]
// CHECK:STDOUT:   %.loc24_45.2: ref %Inner = class_element_access %return, element1
// CHECK:STDOUT:   %MakeInner.call.loc24_44: init %Inner = call %MakeInner.ref.loc24_34() to %.loc24_45.2
// CHECK:STDOUT:   %.loc24_45.3: %struct_type.c.d.1 = struct_literal (%MakeInner.call.loc24_26, %MakeInner.call.loc24_44)
// CHECK:STDOUT:   %.loc24_45.4: init %Outer = class_init (%MakeInner.call.loc24_26, %MakeInner.call.loc24_44), %return
// CHECK:STDOUT:   %.loc24_46: init %Outer = converted %.loc24_45.3, %.loc24_45.4
// CHECK:STDOUT:   return %.loc24_46 to %return
// CHECK:STDOUT: }
// CHECK:STDOUT:
