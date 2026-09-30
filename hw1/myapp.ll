; ModuleID = 'myapp.c'
source_filename = "myapp.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

; Function Attrs: nounwind ssp uwtable(sync)
define void @drawGrid(ptr noundef readonly captures(none) %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %1, %9
  %3 = phi i64 [ 0, %1 ], [ %10, %9 ]
  %4 = mul nuw nsw i64 %3, 2800
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 %4
  %6 = trunc i64 %3 to i32
  %7 = add i32 %6, 418
  br label %12

8:                                                ; preds = %9
  ret void

9:                                                ; preds = %12
  %10 = add nuw nsw i64 %3, 1
  %11 = icmp eq i64 %10, 700
  br i1 %11, label %8, label %2, !llvm.loop !6

12:                                               ; preds = %2, %12
  %13 = phi i64 [ 0, %2 ], [ %18, %12 ]
  %14 = getelementptr inbounds nuw i32, ptr %5, i64 %13
  %15 = load i32, ptr %14, align 4, !tbaa !8
  %16 = trunc i64 %13 to i32
  %17 = add i32 %16, 34
  tail call void @simPutPixel(i32 noundef %7, i32 noundef %17, i32 noundef %15) #5
  %18 = add nuw nsw i64 %13, 1
  %19 = icmp eq i64 %18, 700
  br i1 %19, label %9, label %12, !llvm.loop !12
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: nounwind ssp uwtable(sync)
define float @calcSum(float noundef %0, ptr noundef readonly captures(none) %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #0 {
  %5 = icmp eq i32 %3, 0
  %6 = icmp eq i32 %2, 0
  %7 = icmp eq i32 %2, 699
  br i1 %5, label %8, label %10

8:                                                ; preds = %4
  %9 = mul nsw i32 %2, 700
  br label %21

10:                                               ; preds = %4
  %11 = icmp eq i32 %3, 699
  %12 = add nsw i32 %3, -1
  %13 = mul nsw i32 %2, 700
  %14 = add nsw i32 %12, %13
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds float, ptr %1, i64 %15
  %17 = load float, ptr %16, align 4, !tbaa !13
  %18 = fsub float %17, %0
  %19 = tail call float @simSin(float noundef %18) #5
  %20 = fadd float %19, 0.000000e+00
  br i1 %11, label %33, label %21

21:                                               ; preds = %8, %10
  %22 = phi i32 [ %9, %8 ], [ %13, %10 ]
  %23 = phi float [ 0.000000e+00, %8 ], [ %20, %10 ]
  %24 = phi i32 [ 1, %8 ], [ 2, %10 ]
  %25 = add nsw i32 %3, 1
  %26 = add nsw i32 %25, %22
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds float, ptr %1, i64 %27
  %29 = load float, ptr %28, align 4, !tbaa !13
  %30 = fsub float %29, %0
  %31 = tail call float @simSin(float noundef %30) #5
  %32 = fadd float %23, %31
  br label %33

33:                                               ; preds = %21, %10
  %34 = phi i32 [ 1, %10 ], [ %24, %21 ]
  %35 = phi float [ %20, %10 ], [ %32, %21 ]
  br i1 %6, label %47, label %36

36:                                               ; preds = %33
  %37 = add nuw nsw i32 %34, 1
  %38 = mul i32 %2, 700
  %39 = add i32 %38, -700
  %40 = add nsw i32 %39, %3
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds float, ptr %1, i64 %41
  %43 = load float, ptr %42, align 4, !tbaa !13
  %44 = fsub float %43, %0
  %45 = tail call float @simSin(float noundef %44) #5
  %46 = fadd float %35, %45
  br i1 %7, label %60, label %47

47:                                               ; preds = %33, %36
  %48 = phi i32 [ %38, %36 ], [ 0, %33 ]
  %49 = phi float [ %46, %36 ], [ %35, %33 ]
  %50 = phi i32 [ %37, %36 ], [ %34, %33 ]
  %51 = add nuw nsw i32 %50, 1
  %52 = add i32 %48, 700
  %53 = add nsw i32 %52, %3
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds float, ptr %1, i64 %54
  %56 = load float, ptr %55, align 4, !tbaa !13
  %57 = fsub float %56, %0
  %58 = tail call float @simSin(float noundef %57) #5
  %59 = fadd float %49, %58
  br label %60

60:                                               ; preds = %47, %36
  %61 = phi i32 [ %37, %36 ], [ %51, %47 ]
  %62 = phi float [ %46, %36 ], [ %59, %47 ]
  %63 = uitofp nneg i32 %61 to float
  %64 = fdiv float 1.000000e+01, %63
  %65 = fmul float %62, %64
  ret float %65
}

declare float @simSin(float noundef) local_unnamed_addr #2

; Function Attrs: nounwind ssp uwtable(sync)
define range(i32 -16777216, 0) i32 @calcColour(float noundef %0) local_unnamed_addr #0 {
  %2 = tail call float @simCos(float noundef %0) #5
  %3 = fadd float %2, 1.000000e+00
  %4 = fmul float %3, 5.000000e-01
  %5 = fadd float %0, 0xC000C15240000000
  %6 = tail call float @simCos(float noundef %5) #5
  %7 = fadd float %6, 1.000000e+00
  %8 = fmul float %7, 5.000000e-01
  %9 = fadd float %0, 0xC010C15240000000
  %10 = tail call float @simCos(float noundef %9) #5
  %11 = fadd float %10, 1.000000e+00
  %12 = fmul float %11, 5.000000e-01
  %13 = fmul float %4, 2.550000e+02
  %14 = fptoui float %13 to i32
  %15 = shl i32 %14, 16
  %16 = fmul float %8, 2.550000e+02
  %17 = fptoui float %16 to i32
  %18 = shl i32 %17, 8
  %19 = fmul float %12, 2.550000e+02
  %20 = fptoui float %19 to i32
  %21 = or i32 %15, %18
  %22 = or i32 %21, %20
  %23 = or i32 %22, -16777216
  ret i32 %23
}

declare float @simCos(float noundef) local_unnamed_addr #2

; Function Attrs: nounwind ssp uwtable(sync)
define void @recount(ptr noundef writeonly captures(none) %0, ptr noundef %1, ptr noundef %2, ptr noundef readonly captures(none) %3) local_unnamed_addr #0 {
  tail call void @simMemcpy(ptr noundef %2, ptr noundef %1, i32 noundef 1960000) #5
  br label %5

5:                                                ; preds = %4, %10
  %6 = phi i64 [ 0, %4 ], [ %11, %10 ]
  %7 = mul nuw nsw i64 %6, 700
  %8 = trunc nuw nsw i64 %6 to i32
  br label %13

9:                                                ; preds = %10
  ret void

10:                                               ; preds = %13
  %11 = add nuw nsw i64 %6, 1
  %12 = icmp eq i64 %11, 700
  br i1 %12, label %9, label %5, !llvm.loop !15

13:                                               ; preds = %5, %13
  %14 = phi i64 [ 0, %5 ], [ %54, %13 ]
  %15 = add nuw nsw i64 %14, %7
  %16 = getelementptr inbounds nuw float, ptr %2, i64 %15
  %17 = load float, ptr %16, align 4, !tbaa !13
  %18 = getelementptr inbounds nuw float, ptr %3, i64 %15
  %19 = load float, ptr %18, align 4, !tbaa !13
  %20 = trunc nuw nsw i64 %14 to i32
  %21 = tail call float @calcSum(float noundef %17, ptr noundef %2, i32 noundef %8, i32 noundef %20)
  %22 = fadd float %19, %21
  %23 = tail call float @llvm.fmuladd.f32(float %22, float 0x3FB99999A0000000, float %17)
  %24 = tail call float @simFloatMod(float noundef %23, float noundef 0x401921FB60000000) #5
  %25 = fcmp olt float %24, 0.000000e+00
  %26 = fadd float %24, 0x401921FB60000000
  %27 = select i1 %25, float %26, float %24
  %28 = getelementptr inbounds nuw float, ptr %1, i64 %15
  store float %27, ptr %28, align 4, !tbaa !13
  %29 = tail call float @simFloatMod(float noundef %27, float noundef 0x400921FB60000000) #5
  %30 = fadd float %29, 0x3FD0C15240000000
  %31 = tail call float @simCos(float noundef %30) #5
  %32 = fadd float %31, 1.000000e+00
  %33 = fmul float %32, 5.000000e-01
  %34 = fadd float %30, 0xC000C15240000000
  %35 = tail call float @simCos(float noundef %34) #5
  %36 = fadd float %35, 1.000000e+00
  %37 = fmul float %36, 5.000000e-01
  %38 = fadd float %30, 0xC010C15240000000
  %39 = tail call float @simCos(float noundef %38) #5
  %40 = fadd float %39, 1.000000e+00
  %41 = fmul float %40, 5.000000e-01
  %42 = fmul float %33, 2.550000e+02
  %43 = fptoui float %42 to i32
  %44 = shl i32 %43, 16
  %45 = fmul float %37, 2.550000e+02
  %46 = fptoui float %45 to i32
  %47 = shl i32 %46, 8
  %48 = fmul float %41, 2.550000e+02
  %49 = fptoui float %48 to i32
  %50 = or i32 %44, %47
  %51 = or i32 %50, %49
  %52 = or i32 %51, -16777216
  %53 = getelementptr inbounds nuw i32, ptr %0, i64 %15
  store i32 %52, ptr %53, align 4, !tbaa !8
  %54 = add nuw nsw i64 %14, 1
  %55 = icmp eq i64 %54, 700
  br i1 %55, label %10, label %13, !llvm.loop !16
}

declare void @simMemcpy(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

declare float @simFloatMod(float noundef, float noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #3

; Function Attrs: noreturn nounwind ssp uwtable(sync)
define void @app() local_unnamed_addr #4 {
  %1 = alloca [490000 x i32], align 4
  %2 = alloca [490000 x float], align 4
  %3 = alloca [490000 x float], align 4
  %4 = alloca [490000 x float], align 4
  call void @llvm.lifetime.start.p0(i64 1960000, ptr nonnull %1) #5
  call void @llvm.lifetime.start.p0(i64 1960000, ptr nonnull %2) #5
  call void @llvm.lifetime.start.p0(i64 1960000, ptr nonnull %3) #5
  call void @llvm.lifetime.start.p0(i64 1960000, ptr nonnull %4) #5
  call void @simIntMemset(ptr noundef nonnull %1, i32 noundef 0, i32 noundef 1960000) #5
  call void @simFloatMemset(ptr noundef nonnull %2, i32 noundef 0, i32 noundef 1960000) #5
  call void @simFloatMemset(ptr noundef nonnull %4, i32 noundef 0, i32 noundef 1960000) #5
  br label %5

5:                                                ; preds = %0, %8
  %6 = phi i64 [ 0, %0 ], [ %9, %8 ]
  %7 = mul nuw nsw i64 %6, 700
  br label %11

8:                                                ; preds = %11
  %9 = add nuw nsw i64 %6, 1
  %10 = icmp eq i64 %9, 700
  br i1 %10, label %25, label %5, !llvm.loop !17

11:                                               ; preds = %5, %11
  %12 = phi i64 [ 0, %5 ], [ %23, %11 ]
  %13 = call i32 @simRand() #5
  %14 = sitofp i32 %13 to float
  %15 = call float @simFloatMod(float noundef %14, float noundef 0x401921FB60000000) #5
  %16 = add nuw nsw i64 %12, %7
  %17 = getelementptr inbounds nuw [490000 x float], ptr %2, i64 0, i64 %16
  store float %15, ptr %17, align 4, !tbaa !13
  %18 = call i32 @simRand() #5
  %19 = srem i32 %18, 100
  %20 = sitofp i32 %19 to float
  %21 = fdiv float %20, 1.000000e+02
  %22 = getelementptr inbounds nuw [490000 x float], ptr %4, i64 0, i64 %16
  store float %21, ptr %22, align 4, !tbaa !13
  %23 = add nuw nsw i64 %12, 1
  %24 = icmp eq i64 %23, 700
  br i1 %24, label %8, label %11, !llvm.loop !18

25:                                               ; preds = %8, %43
  call void @recount(ptr noundef nonnull %1, ptr noundef nonnull %2, ptr noundef nonnull %3, ptr noundef nonnull %4)
  br label %26

26:                                               ; preds = %32, %25
  %27 = phi i64 [ 0, %25 ], [ %33, %32 ]
  %28 = mul nuw nsw i64 %27, 2800
  %29 = getelementptr inbounds nuw i8, ptr %1, i64 %28
  %30 = trunc i64 %27 to i32
  %31 = add i32 %30, 418
  br label %35

32:                                               ; preds = %35
  %33 = add nuw nsw i64 %27, 1
  %34 = icmp eq i64 %33, 700
  br i1 %34, label %43, label %26, !llvm.loop !6

35:                                               ; preds = %35, %26
  %36 = phi i64 [ 0, %26 ], [ %41, %35 ]
  %37 = getelementptr inbounds nuw i32, ptr %29, i64 %36
  %38 = load i32, ptr %37, align 4, !tbaa !8
  %39 = trunc i64 %36 to i32
  %40 = add i32 %39, 34
  call void @simPutPixel(i32 noundef %31, i32 noundef %40, i32 noundef %38) #5
  %41 = add nuw nsw i64 %36, 1
  %42 = icmp eq i64 %41, 700
  br i1 %42, label %32, label %35, !llvm.loop !12

43:                                               ; preds = %32
  call void @simFlush() #5
  br label %25
}

declare void @simIntMemset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

declare void @simFloatMemset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

declare i32 @simRand(...) local_unnamed_addr #2

declare void @simFlush(...) local_unnamed_addr #2

attributes #0 = { nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+bti,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+bti,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { noreturn nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+bti,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a" }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!9, !9, i64 0}
!9 = !{!"int", !10, i64 0}
!10 = !{!"omnipotent char", !11, i64 0}
!11 = !{!"Simple C/C++ TBAA"}
!12 = distinct !{!12, !7}
!13 = !{!14, !14, i64 0}
!14 = !{!"float", !10, i64 0}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
!18 = distinct !{!18, !7}
