import 'package:isar/isar.dart';

part 'shops.g.dart';

@collection
class Shop {
  Shop({
    required this.id,
    required this.name,
    required this.longName,
    required this.address,
    required this.lat,
    required this.lng,
  });

  Id id;
  String name;
  String longName;
  String address;
  double lat;
  double lng;
}
