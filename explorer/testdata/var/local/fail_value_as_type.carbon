// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

fn Main() -> i32 {
  // 42 cannot be used as the type of a variable.
  // CHECK:STDERR: COMPILATION ERROR: fail_value_as_type.carbon:[[@LINE+1]]: type error in type of name binding: 'i32' is not implicitly convertible to 'type'
  var x: 42 = 0;
  return x;
}
