import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
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
    await ref.read(shopNotifierProvider.notifier).insertShop(newShop);
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
      child: const Text('ダミーデータの追加'),
    );
  }
}
