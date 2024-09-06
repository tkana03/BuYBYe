import 'package:http/http.dart' as http;

Future<http.Response> multipart({
  required String method,
  required Uri url,
  required List<http.MultipartFile> files,
}) async {
  final request = http.MultipartRequest(method, url);

  request.files.addAll(files); // 送信するファイルのバイナリデータを追加
  // request.headers.addAll({'Authorization': 'Bearer xxxxxx'}); // 認証情報などを追加

  final stream = await request.send();

  return http.Response.fromStream(stream).then((response) {
    if (response.statusCode == 200) {
      return response;
    }

    return Future.error(response);
  });
}
