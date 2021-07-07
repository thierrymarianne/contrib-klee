; LLVM has an intrinsic for abs.
; This file is based on the following code with poisoning of llvm.abs disabled.
; ```
; #include "klee/klee.h"
;
; #include <assert.h>
; #include <limits.h>
;
; volatile int abs_a;
;
; int main(void)
; {
;   int a;
;   klee_make_symbolic(&a, sizeof(a), "a");
;
;   abs_a = a < 0 ? -a : a;
;   if (abs_a == INT_MIN)
;     assert(abs_a == a);
;   else
;     assert(abs_a >= 0);
;   return abs_a;
; }
; ```
; REQUIRES: geq-llvm-12.0
; RUN: %llvmas %s -o=%t.bc
; RUN: rm -rf %t.klee-out
; RUN: %klee -exit-on-error --output-dir=%t.klee-out --optimize=false %t.bc
; ModuleID = 'abs-no-overflow.ll'
source_filename = "abs-no-overflow.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@0 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@abs_a = dso_local global i32 0, align 4
@1 = private unnamed_addr constant [11 x i8] c"abs_a == a\00", align 1
@2 = private unnamed_addr constant [7 x i8] c"test.c\00", align 1
@3 = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@4 = private unnamed_addr constant [11 x i8] c"abs_a >= 0\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %2) #5
  call void @klee_make_symbolic(i8* nonnull %2, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @0, i64 0, i64 0)) #5
  %3 = load i32, i32* %1, align 4, !tbaa !0
  %4 = call i32 @llvm.abs.i32(i32 %3, i1 false)
  store volatile i32 %4, i32* @abs_a, align 4, !tbaa !0
  %5 = load volatile i32, i32* @abs_a, align 4, !tbaa !0
  %6 = icmp eq i32 %5, -2147483648
  %7 = load volatile i32, i32* @abs_a, align 4, !tbaa !0
  br i1 %6, label %8, label %11

8:                                                ; preds = %0
  %9 = icmp eq i32 %7, %3
  br i1 %9, label %14, label %10

10:                                               ; preds = %8
  call void @__assert_fail(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @1, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @2, i64 0, i64 0), i32 15, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @3, i64 0, i64 0)) #6
  unreachable

11:                                               ; preds = %0
  %12 = icmp sgt i32 %7, -1
  br i1 %12, label %14, label %13

13:                                               ; preds = %11
  call void @__assert_fail(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @4, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @2, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @3, i64 0, i64 0)) #6
  unreachable

14:                                               ; preds = %11, %8
  %15 = load volatile i32, i32* @abs_a, align 4, !tbaa !0
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %2) #5
  ret i32 %15
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare dso_local void @klee_make_symbolic(i8*, i64, i8*) local_unnamed_addr #2

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) local_unnamed_addr #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.abs.i32(i32, i1 immarg) #4

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!0 = !{!1, !1, i64 0}
!1 = !{!"int", !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C/C++ TBAA"}
