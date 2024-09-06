import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraStateNotifier extends StateNotifier<CameraController?> {
  CameraStateNotifier() : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;
      final controller = CameraController(
        camera,
        // ResolutionPreset.medium,
        ResolutionPreset.max,
      );

      // await controller.initialize();
      state = controller;
    } catch (e) {
      // エラー処理
      debugPrint('カメラの初期化中にエラーが発生しました: $e');
      // 必要であれば、エラー状態を state に反映させる
    }
  }
}

final cameraNotifierProvider =
    StateNotifierProvider<CameraStateNotifier, CameraController?>(
        (ref) => CameraStateNotifier());

// /// カメラコントローラ用のプロバイダー
// final cameraControllerProvider =
//     FutureProvider.autoDispose<CameraController>((ref) async {
//   final cameras = await availableCameras();
//   // 内カメをセット　※0: 外カメ　1: 内カメ
//   final camera = cameras.first;
//   final controller = CameraController(
//     camera,
//     ResolutionPreset.medium,
//   );

//   // プロバイダーの破棄時にカメラコントローラを破棄する
//   ref.onDispose(() {
//     controller.dispose();
//   });

//   // コントローラを初期化
//   await controller.initialize();
//   return controller;
// });

// /// 戻るボタン押下時処理
// void onPressBackButton(BuildContext context) {
//   // 前の画面へ戻る
//   Navigator.pop(context);
// }

// /// 写真撮影ボタン押下時処理
// Future<void> onPressTakePictureButton(
//     BuildContext context, CameraController controller) async {
//   final image = await controller.takePicture();
//   // Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => ConfirmPictureScreen(image: image))
//   // );
// }
