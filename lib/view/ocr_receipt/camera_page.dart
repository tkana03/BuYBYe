import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/ocr_receipt/result_page.dart';
import 'package:flutter_application_1/view/read_receipt_screen/receipt_item.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/utils.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.camera_controller,
    required this.future,
  });

  final CameraController camera_controller;
  final Future<void>? future;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);

  @override
  Widget build(BuildContext context) {
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      appBar: AppBar(
        title: const Text('レシートを読み取って下さい'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: CameraPreview(widget.camera_controller),
        // child: FutureBuilder<void>(
        //   future: future,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       return CameraPreview(_controller);
        //     } else {
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //   },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // 写真を撮る
            final image = await widget.camera_controller.takePicture();
            debugPrint(image.path);

            // 画像ファイルを開く -> base64に変換 -> APIに投げる(HTTPリクエスト) -> jsonいい感じに整形 -> 表示/DB
            // *** call API
            final apiKey = dotenv.get("API_KEY");
            debugPrint(apiKey);

            File imgFile = File(image.path);
            final inputImage = InputImage.fromFile(imgFile);
            final recognizedText =
                await textRecognizer.processImage(inputImage);

            final prompt = '''
あなたは高精度なレシートOCRシステムです。OCRで抽出されたテキストとレシート画像の両方を入力として受け取り、レシートの内容を正確にテキスト化します。

OCRの結果は参考情報として利用しますが、誤字脱字や認識ミスが含まれる可能性があることを考慮してください。
レシート画像を分析し、OCRの結果と照らし合わせて、以下の項目を含むようにテキスト化してください。
なお，出力は、CSV形式で、以下のヘッダー行を含むようにし，下記に示すようにデータを整形してください:

header: name, price, status, category, deadline

statusは商品の状態を表し、1:常温 2:冷蔵 3:冷凍の3つがあり，これらのうちどれかを選択して入力してください．
categoryは商品のカテゴリを表し、１：食料品，２：日用品の二つがあり，どちらかを選択して入力してください．
deadlineは食料品なら賞味期限．消費期限を表し，日用品なら次に購入するまでの目安日を表します．
status,category,deadlineは商品名から予測して入力してください．
deadlineのみ，推測できない場合にはレシートの日付から1ヶ月後の日時を入力してください．
もし商品名の先頭に，[内*]や[内]の文字があった場合は，その文字を削除したものを商品名として保存してください．

入力例：
商品名A,100,常温,食料品,2024-09-21
商品名B,200,常温,日用品,2024-10-31

<ocrの結果>
${recognizedText.text}''';

            '''
// タスク1: 撮影 -> OCR -> 商品追加
header: 商品, 金額, 個数
A, 100, 1
B, 200, 2

-> 各行をsplitして[0]-[2]でアクセス -> 登録


// フィルタリング用のカテゴリ
{
  "食料品 (EN)": [
    "米"
    ...
  ],
  "日用品 (EN)": [
    "abc"
    ...
  ]
}
''';

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
            final textdata =
                data["candidates"][0]["content"]["parts"][0]["text"];
            // final textdata = data["candidates"];
            print(textdata);
            //   "candidates": [{ "content": { "parts": [{ "text": ここ

            if (response.statusCode == 200) {
              print('Response data: ${response.body}');
              // レスポンスからCSVデータを抽出
              final csvData = textdata.split('\n').sublist(2); // ヘッダー行と空行をスキップ
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

                print(ar);
                // print(ar[1]);
                // print(ar[2]);
                // print(ar[3]);
                // print(ar[4]);

                final item = ReceiptItem()
                  ..name = ar[0]
                  ..price = int.parse(ar[1])
                  ..status = ar[2]
                  ..category = ar[3]
                  ..deadline = ar[4];
                items.add(item);
              }

              print("aaa");
              print(items);
              for (var item in items) {
                print(item.name);
              }

              // ..image = ...

              // CSVデータを文字列に変換
              String csvString =
                  receiptData.map((row) => row.join(',')).join('\n');

              // 次の画面にデータを渡す
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    text: csvString, // CSVデータを文字列として渡す
                  ),
                  fullscreenDialog: true,
                ),
              );

              // // レスポンスから必要なデータを抽出して保存する
              // // TODO: CSVデータの処理、DB保存処理の実装
              // saveReceiptData(response.body);
            } else {
              print('Request failed with status: ${response.statusCode}');
            }

            // ...

            // final inputImage = InputImage.fromFile(file);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('失敗'),
              ),
            );
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// レシートデータの保存処理（仮実装）
// TODO: Isarデータベースへの保存処理を実装する
void saveReceiptData(String csvData) {
  // CSVデータから必要なデータを抽出
  // ...

  // データベースへの保存処理
  // ...
}

// TODO: Isarデータベースへの保存処理
// class Receipt {
//   String storeName;
//   String date;
//   String time;
//   List<String> products;
//   List<int> prices;
//   List<int> quantities;
//   int totalPrice;
// }

// // CSVデータからReceiptオブジェクトを作成
// Receipt createReceiptFromCSV(String csvData) {
//   // CSVデータから必要なデータを抽出
//   // ...

//   // Receiptオブジェクトを作成
//   Receipt receipt = Receipt(
//     storeName: '',
//     date: '',
//     time: '',
//     products: [],
//     prices: [],
//     quantities: [],
//     totalPrice: 0,
//   );
//   return receipt;
// }