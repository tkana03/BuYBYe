import 'package:flutter_application_1/schema/shops.dart';
import 'package:isar/isar.dart';

part 'wish_list_item.g.dart';

@collection
class WishListItem {
  WishListItem({
    required this.id,
  });

  Id id = Isar.autoIncrement;
  String? name;
  final shop = IsarLink<Shop>();
}
