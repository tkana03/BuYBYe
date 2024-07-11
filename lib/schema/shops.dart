import 'package:isar/isar.dart';

part 'shops.g.dart';

@collection
class Shop {
  Shop({
    required this.id,
    required this.name,
    required this.address,
    // required this.description,
  });

  // Id id = Isar.autoIncrement;
  Id id;
  String name;
  String address;
  String? description;
  // todo: GPS用データ（緯度、経度）
}
