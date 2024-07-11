import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Isarインスタンスを提供するProvider
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [ShopSchema], // todo: 全てのSchemaを指定する
    directory: dir.path,
  );
});

class AppRepository {
  final Ref ref;

  late final ShopNotifier shops = ref.read(shopNotifierProvider.notifier);

  AppRepository(this.ref);
}
