// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/if/fail_scope.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/if/fail_scope.carbon

fn VarScope(b: bool) -> i32 {
  if (b) {
    var n: i32 = 2;
    return n;
  }
  // CHECK:STDERR: fail_scope.carbon:[[@LINE+3]]:10: error: name `n` not found [NameNotFound]
  // CHECK:STDERR:   return n;
  // CHECK:STDERR:          ^
  return n;
}

// CHECK:STDOUT: --- fail_scope.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Bool.type: type = fn_type @Bool [template]
// CHECK:STDOUT:   %Bool: %Bool.type = struct_value () [template]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %VarScope.type: type = fn_type @VarScope [template]
// CHECK:STDOUT:   %VarScope: %VarScope.type = struct_value () [template]
// CHECK:STDOUT:   %int_2.1: Core.IntLiteral = int_value 2 [template]
// CHECK:STDOUT:   %Convert.type.2: type = fn_type @Convert.1, @ImplicitAs(%i32) [template]
// CHECK:STDOUT:   %Convert.type.10: type = fn_type @Convert.2, @impl.1(%int_32) [template]
// CHECK:STDOUT:   %Convert.10: %Convert.type.10 = struct_value () [template]
// CHECK:STDOUT:   %interface.19: <witness> = interface_witness (%Convert.10) [template]
// CHECK:STDOUT:   %Convert.bound: <bound method> = bound_method %int_2.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn: <specific function> = specific_function %Convert.bound, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_2.2: %i32 = int_value 2 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Bool = %import_ref.1
// CHECK:STDOUT:     .Int = %import_ref.2
// CHECK:STDOUT:     .ImplicitAs = %import_ref.6
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .VarScope = %VarScope.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %VarScope.decl: %VarScope.type = fn_decl @VarScope [template = constants.%VarScope] {
// CHECK:STDOUT:     %b.patt: bool = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: bool = value_param_pattern %b.patt, runtime_param0
// CHECK:STDOUT:     %return.patt: %i32 = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %i32 = out_param_pattern %return.patt, runtime_param1
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int_32: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:     %i32: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:     %b.param: bool = value_param runtime_param0
// CHECK:STDOUT:     %.loc11_16.1: type = splice_block %.loc11_16.3 [template = bool] {
// CHECK:STDOUT:       %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:       %.loc11_16.2: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:       %.loc11_16.3: type = converted %bool.make_type, %.loc11_16.2 [template = bool]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %b: bool = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref %i32 = out_param runtime_param1
// CHECK:STDOUT:     %return: ref %i32 = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @VarScope(%b.param_patt: bool) -> %i32 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %b.ref: bool = name_ref b, %b
// CHECK:STDOUT:   if %b.ref br !if.then else br !if.else
// CHECK:STDOUT:
// CHECK:STDOUT: !if.then:
// CHECK:STDOUT:   %n.var: ref %i32 = var n
// CHECK:STDOUT:   %n: ref %i32 = bind_name n, %n.var
// CHECK:STDOUT:   %int_2: Core.IntLiteral = int_value 2 [template = constants.%int_2.1]
// CHECK:STDOUT:   %impl.elem0: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound: <bound method> = bound_method %int_2, %impl.elem0 [template = constants.%Convert.bound]
// CHECK:STDOUT:   %Convert.specific_fn: <specific function> = specific_function %Convert.bound, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn]
// CHECK:STDOUT:   %int.convert_checked: init %i32 = call %Convert.specific_fn(%int_2) [template = constants.%int_2.2]
// CHECK:STDOUT:   %.loc13: init %i32 = converted %int_2, %int.convert_checked [template = constants.%int_2.2]
// CHECK:STDOUT:   assign %n.var, %.loc13
// CHECK:STDOUT:   %n.ref.loc14: ref %i32 = name_ref n, %n
// CHECK:STDOUT:   %.loc14: %i32 = bind_value %n.ref.loc14
// CHECK:STDOUT:   return %.loc14
// CHECK:STDOUT:
// CHECK:STDOUT: !if.else:
// CHECK:STDOUT:   %n.ref.loc19: <error> = name_ref n, <error> [template = <error>]
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
