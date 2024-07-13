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
      longName: 'Shop x (Long Name)',
      address: 'Address x',
      lat: 0,
      lng: 0,
    );
    await ref.watch(shopNotifierProvider.notifier).insertShop(newShop);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => insertShop(ref),
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
      state: 'State x',
      purchaseDate: '2022-01-01',
      deadline: '2022-01-01',
      category: 'Category x',
    );
    await ref.watch(itemNotifierProvider.notifier).insertItem(newItem);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => insertItem(ref),
      child: const Text('商品ダミーデータの追加'),
    );
  }
}
