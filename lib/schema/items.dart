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
    required this.image,
  });

  // todo: DateTimeもDBに保存するなら、コンストラクタで処理する
  // 保存しておくと items.where() で日付の条件指定ができるようになるから、やった方がいいかもしれない

  // Id id = Isar.autoIncrement;
  Id id;
  String name;
  String state;
  String purchaseDate;
  //DateTime型にする？
  //Datetime(2020, 10, 2, 12, 10)
  String deadline;
  String category;
  String image;

  DateTime get purchaseDatetime => DateTime.parse(purchaseDate);
  DateTime get deadlineDatetime => DateTime.parse(deadline);
}


// このファイルを変更したら↓を実行
// flutter pub run build_runner build