// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

class Point {
  var x: i32;
  var y: i32;
}

fn Main() -> i32 {
  var p: Point = {.x = 1, .y = 2};
  // CHECK:STDERR: COMPILATION ERROR: fail_field_access_mismatch.carbon:[[@LINE+1]]: class Point does not have a field named z
  return p.z - 1;
}
