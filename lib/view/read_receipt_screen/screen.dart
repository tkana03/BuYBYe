import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/camera_provider.dart';
import 'package:flutter_application_1/view/read_receipt_screen/receipt_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 写真撮影画面
class ReadReceiptScreen extends HookConsumerWidget {
  const ReadReceiptScreen({
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 35),
            const Center(
                child: Text('レシート撮影',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),
            FutureBuilder<void>(
              future: initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 写真を撮る
          final image = await controller.takePicture();
          // path を出力
          debugPrint(image.path);

          await Future.delayed(const Duration(seconds: 3));

          // ignore: use_build_context_synchronously
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RegisterItemScreen()));
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
