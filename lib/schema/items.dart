import 'package:isar/isar.dart';

part 'items.g.dart';

@collection
class Item {
  Item({
    required this.id,
    required this.name,
    // required this.期限...
    // required this.description,
  });

  // Id id = Isar.autoIncrement;
  Id id;
  String name;
  // Date... 期限;
  String? description;
}


// このファイルを変更したら↓を実行
// flutter pub run build_runner build