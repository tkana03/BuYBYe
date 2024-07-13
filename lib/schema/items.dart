import 'package:isar/isar.dart';

part 'items.g.dart';

@collection
class Item {
  Item({
    required this.id,
    required this.name,
    required this.state,
    required this.purchaseDate,
    required this.deadline,
    required this.category,

    // required this.期限...
    // required this.description,
  });

  // Id id = Isar.autoIncrement;
  Id id;
  String name;
  String state;
  String purchaseDate;
  //DateTime型にする？
  //Datetime(2020, 10, 2, 12, 10)
  String deadline;
  String category;
  // Date... 期限;
  String? description;
}


// このファイルを変更したら↓を実行
// flutter pub run build_runner build