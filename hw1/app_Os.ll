; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx16.0.0"

; Function Attrs: nounwind optsize ssp uwtable(sync)
define void @app() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %7
  %2 = phi i32 [ 0, %0 ], [ %8, %7 ]
  br label %4

3:                                                ; preds = %7
  ret void

4:                                                ; preds = %1, %10
  %5 = phi i32 [ 0, %1 ], [ %11, %10 ]
  %6 = mul nuw nsw i32 %5, %2
  br label %13

7:                                                ; preds = %10
  tail call void @simFlush() #2
  %8 = add nuw nsw i32 %2, 1
  %9 = icmp eq i32 %8, 1000
  br i1 %9, label %3, label %1, !llvm.loop !5

10:                                               ; preds = %13
  %11 = add nuw nsw i32 %5, 1
  %12 = icmp eq i32 %11, 768
  br i1 %12, label %7, label %4, !llvm.loop !7

13:                                               ; preds = %4, %13
  %14 = phi i32 [ 0, %4 ], [ %17, %13 ]
  %15 = mul nuw nsw i32 %6, %14
  %16 = add nsw i32 %15, -16777216
  tail call void @simPutPixel(i32 noundef %14, i32 noundef %5, i32 noundef %16) #2
  %17 = add nuw nsw i32 %14, 1
  %18 = icmp eq i32 %17, 1536
  br i1 %18, label %10, label %13, !llvm.loop !8
}

; Function Attrs: optsize
declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: optsize
declare void @simFlush(...) local_unnamed_addr #1

attributes #0 = { nounwind optsize ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { optsize "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { nounwind optsize }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 1}
!4 = !{!"Homebrew clang version 18.1.8"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
