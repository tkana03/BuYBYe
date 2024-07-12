import 'package:isar/isar.dart';

part 'items.g.dart';

@collection
class Item {
  Item({
    required this.id,
    required this.name,
    // required this.description,
  });

  // Id id = Isar.autoIncrement;
  Id id;
  String name;
  String? description;
}
