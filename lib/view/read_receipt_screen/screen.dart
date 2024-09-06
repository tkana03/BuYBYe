import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/camera_provider.dart';
import 'package:flutter_application_1/view/read_receipt_screen/receipt_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/const.dart' as const_var;

/// 写真撮影画面
class ReadReceiptScreen extends HookConsumerWidget {
  const ReadReceiptScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(cameraNotifierProvider);
    final initializeControllerFuture = controller?.initialize();
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.japanese);

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
          // 登録済みの商品をクリア
          ref.read(registerItemProvider.notifier).clearItems();

          // 写真を撮る
          final image = await controller.takePicture();
          debugPrint(image.path);

          // 画像ファイルを開く -> base64に変換 -> APIに投げる(HTTPリクエスト) -> jsonいい感じに整形 -> 表示/DB
          final apiKey = dotenv.get("API_KEY");
          debugPrint(apiKey);

          File imgFile = File(image.path);
          final inputImage = InputImage.fromFile(imgFile);
          final recognizedText = await textRecognizer.processImage(inputImage);

          final prompt = '''
あなたは高精度なレシートOCRシステムです。OCRで抽出されたテキストとレシート画像の両方を入力として受け取り、レシートの内容を正確にテキスト化します。

OCRの結果は参考情報として利用しますが、誤字脱字や認識ミスが含まれる可能性があることを考慮してください。
レシート画像を分析し、OCRの結果と照らし合わせて、以下の項目を含むようにテキスト化してください。
なお，出力は、CSV形式で、以下のヘッダー行を含むようにし，下記に示すようにデータを整形してください:

header: name, price, status, category, deadline

statusは商品の状態を表し、[常温] [冷蔵] [冷凍]の3つがあり，これらのうちどれかを選択して入力してください．
categoryは商品のカテゴリを表し、[食料品]，[日用品]の二つがあり，どちらかを選択して入力してください．
deadlineは食料品なら賞味期限．消費期限を表し，日用品なら次に購入するまでの目安日を表します．
status,category,deadlineは商品名から予測して入力してください．
deadlineのみ，推測できない場合にはレシートの日付から1ヶ月後の日時を入力してください．
もし商品名の先頭に，[内*]や[内]の文字があった場合は，その文字を削除したものを商品名として保存してください．

入力例：
商品名A,100,常温,食料品,2024-09-21
商品名B,200,常温,日用品,2024-10-31

<ocrの結果>
${recognizedText.text}''';

          final headers = {
            'Content-Type': 'application/json',
          };
          final response = await http.post(
            Uri.https(
              'generativelanguage.googleapis.com',
              '/v1/models/gemini-1.5-flash:generateContent',
              {"key": apiKey},
            ),
            headers: headers,
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": prompt},
                    {
                      "inlineData": {
                        "mimeType": "image/jpeg",
                        "data": base64.encode(imgFile.readAsBytesSync())
                      }
                    }
                  ]
                }
              ]
            }),
          );

          final data = jsonDecode(response.body);
          final textdata = data["candidates"][0]["content"]["parts"][0]["text"];
          print(textdata);

          if (response.statusCode != 200) {
            print("statusCode is not 200.");
            return;
          }

          print('Response data: ${response.body}');
          // レスポンスからCSVデータを抽出
          final csvData = textdata.split('\n').sublist(1); // ヘッダー行と空行をスキップ
          // CSVデータをリストに変換
          List<List<String>> receiptData = [];
          List<ReceiptItem> items = [];
          for (String line in csvData) {
            final ar = line
                .replaceAll("\"", "")
                .split(',')
                .map((e) => e.trim())
                .toList();
            if (ar.length < 5) {
              continue;
            }
            receiptData.add(ar);

            final item = ReceiptItem()
              ..name = ar[0]
              ..price = int.parse(ar[1])
              ..status = ar[2]
              ..category = ar[3]
              ..deadline = ar[4]
              ..purchase = DateFormat("yyyy-MM-dd").format((DateTime.now()))
              ..image = const_var.imgUnknownPath;

            items.add(item);
          }

          for (var item in items) {
            print("add item: ${item.name}");
          }
          for (var item in items) {
            ref.read(registerItemProvider.notifier).addItem(item);
          }

          // ignore: use_build_context_synchronously
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RegisterItemScreen()));
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
