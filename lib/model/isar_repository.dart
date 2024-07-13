import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/schema/items.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:flutter_application_1/schema/wish_list_item.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarRepository {
  IsarRepository();

  static Isar get isar => _isar!;
  static Isar? _isar;

  // static bool isInitializeInProgress = false;
  static Future<void> configure() async {
    // if (!isInitializeInProgress) {
    //   isInitializeInProgress = true;
    //   await waitForInitialize();
    //   isInitializeInProgress = false;
    // }
    if (_isar != null) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    // await Isar.getInstance()?.close(deleteFromDisk: true);
    _isar = await Isar.open([ItemSchema, ShopSchema, WishListItemSchema],
        directory: dir.path, inspector: true);

    debugPrint("isar opened");
  }

  // static Future<void> waitForInitialize() async {
  //   while (!isInitializeInProgress) {
  //     await Future.delayed(const Duration(milliseconds: 1000));
  //   }
  // }
}
