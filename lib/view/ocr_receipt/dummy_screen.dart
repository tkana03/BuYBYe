import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/camera_provider.dart';
import 'package:flutter_application_1/view/ocr_receipt/camera_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OcrReceiptWidget extends HookConsumerWidget {
  const OcrReceiptWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(cameraNotifierProvider);
    final initializeControllerFuture = controller?.initialize();

    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      body: CameraPage(
          camera_controller: controller, future: initializeControllerFuture),
    );
  }
}
