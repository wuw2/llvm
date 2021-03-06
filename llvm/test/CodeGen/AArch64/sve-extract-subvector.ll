; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; Test that DAGCombiner doesn't drop the scalable flag when it tries to fold:
;   extract_subv (bitcast X), Index --> bitcast (extract_subv X, Index')
define <vscale x 16 x i8> @extract_nxv16i8_nxv4i64(<vscale x 4 x i64> %z0_z1) {
; CHECK-LABEL: extract_nxv16i8_nxv4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    ret
  %z0_z1_bc = bitcast <vscale x 4 x i64> %z0_z1 to <vscale x 32 x i8>
  %ext = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv32i8(<vscale x 32 x i8> %z0_z1_bc, i32 1)
  ret <vscale x 16 x i8> %ext
}


define <vscale x 2 x i64> @extract_nxv2i64_nxv32i8(<vscale x 32 x i8> %z0_z1) {
; CHECK-LABEL: extract_nxv2i64_nxv32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    ret
  %z0_z1_bc = bitcast <vscale x 32 x i8> %z0_z1 to <vscale x 4 x i64>
  %ext = call <vscale x 2 x i64> @llvm.aarch64.sve.tuple.get.nxv4i64(<vscale x 4 x i64> %z0_z1_bc, i32 1)
  ret <vscale x 2 x i64> %ext
}

declare <vscale x 2 x i64> @llvm.aarch64.sve.tuple.get.nxv4i64(<vscale x 4 x i64>, i32)
declare <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv32i8(<vscale x 32 x i8>, i32)
