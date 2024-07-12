import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/item_provider.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_application_1/schema/items.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class ShopDummyInsertButton extends ConsumerWidget {
  const ShopDummyInsertButton({super.key});

  void insertShop(WidgetRef ref) async {
    final newShop = Shop(
      id: Isar.autoIncrement,
      name: 'Shop x',
      address: 'Address x',
    );
    // await ref.read(shopRepositoryProvider.notifier).insertShop(newShop);
    await ref.watch(shopNotifierProvider.notifier).insertShop(newShop);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => insertShop(ref),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('店舗ダミーデータの追加'),
    );
  }
}

class ItemDummyInsertButton extends ConsumerWidget {
  const ItemDummyInsertButton({super.key});

  void insertItem(WidgetRef ref) async {
    final newItem = Item(
      id: Isar.autoIncrement,
      name: 'Item x',
    );
    // await ref.read(shopRepositoryProvider.notifier).insertShop(newShop);
    await ref.watch(itemNotifierProvider.notifier).insertItem(newItem);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => insertItem(ref),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('商品ダミーデータの追加'),
    );
  }
}
