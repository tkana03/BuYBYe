import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/insert_dummy_data_button.dart';
import 'package:flutter_application_1/provider/item_provider.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ShopList extends ConsumerWidget {
  const ShopList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(shopNotifierProvider);
    final items = ref.watch(itemNotifierProvider);

    final now = DateTime.now();
    final dateFormat = DateFormat('MM月dd日');

    // 食料品と日用品のフィルタリング処理
    final filteredFoodItems = items.where((item) {
      final daysLeft = item.deadlineDatetime.difference(now).inDays;
      return item.category == '食料品' && daysLeft <= 7;
    }).toList();

    final filteredDailyItems = items.where((item) {
      final daysLeft = item.deadlineDatetime.difference(now).inDays;
      return item.category == '日用品' && daysLeft <= 14;
    }).toList();

    return Column(
      children: [
        const ShopDummyInsertButton(),
        Expanded(
          child: ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              return ListTile(
                horizontalTitleGap: 30,
                title: Row(
                  children: [
                    Image.network(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                      height: 42,
                      width: 42,
                    ),
                    const SizedBox(width: 16),
                    Text(shops[index].name),
                  ],
                ),
              );
            },
          ),
        ),
        const ItemDummyInsertButton(),
        const SizedBox(height: 16),
        const Text(
          '食料品',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFoodItems.length,
            itemBuilder: (context, index) {
              final item = filteredFoodItems[index];
              final daysLeft = item.deadlineDatetime.difference(now).inDays;

              return SizedBox(
                height: 100,
                child: ListTile(
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                          height: 70,
                          width: 70,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStateColor(item.state),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    item.state,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart, size: 16),
                                    Text(
                                      ' ${dateFormat.format(item.purchaseDatetime)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16), // スペースを追加
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.watch_later, size: 16),
                                        Text(
                                          ' あと',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '$daysLeft',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Text(
                                          '日',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '日用品',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredDailyItems.length,
            itemBuilder: (context, index) {
              final item = filteredDailyItems[index];
              final daysLeft = item.deadlineDatetime.difference(now).inDays;

              return SizedBox(
                height: 100,
                child: ListTile(
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                          height: 70,
                          width: 70,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStateColor(item.state),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    item.state,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart, size: 16),
                                    Text(
                                      ' ${dateFormat.format(item.purchaseDatetime)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16), // スペースを追加
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.watch_later, size: 16),
                                        Text(
                                          ' あと',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '$daysLeft',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Text(
                                          '日',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // stateに応じた色を返す関数
  Color _getStateColor(String state) {
    switch (state) {
      case '冷蔵':
        return Colors.blue;
      case '冷凍':
        return Colors.cyan;
      case '常温':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
