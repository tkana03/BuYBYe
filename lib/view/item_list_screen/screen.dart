import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ItemListScreen extends ConsumerWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemNotifierProvider);

    final now = DateTime.now();
    final dateFormat = DateFormat('M月d日');

    // 食料品と日用品のフィルタリング処理
    final filteredFoodItems =
        items.where((item) => item.category == "食料品").toList()
          ..sort((a, b) => a.deadlineDatetime
              // .difference(now)
              // .inDays
              .compareTo(b.deadlineDatetime));

    final filteredDailyItems =
        items.where((item) => item.category == "日用品").toList()
          ..sort((a, b) => a.deadlineDatetime
              // .difference(now)
              // .inDays
              .compareTo(b.deadlineDatetime));

    // 両方のリストを一つのListViewで表示
    final combinedList = <Widget>[
      const SizedBox(height: 16),
      const Center(
          child: Text(
        '食料品',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
      const SizedBox(height: 16),
      ...filteredFoodItems.map((item) {
        final daysLeft = item.deadlineDatetime.difference(now).inDays;

        return ListTile(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item.image.startsWith("assets")
                    ? Image.asset(item.image, height: 70, width: 70)
                    : Image.network(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                        height: 70,
                        width: 70),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 17,
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15), // スペースを追加
                        Expanded(
                          child: Center(
                            child: Row(
                              children: [
                                const Icon(Icons.watch_later, size: 16),
                                Text(
                                  ' ${dateFormat.format(item.deadlineDatetime)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                // const Text(
                                //   ' あと',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //   ),
                                // ),
                                // Text(
                                //   '$daysLeft日',
                                //   style: const TextStyle(
                                //     fontSize: 15,
                                //     color: Colors.red,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
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
        );
      }),
      const SizedBox(height: 16),
      const Center(
        child: Text(
          '日用品',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 16),
      ...filteredDailyItems.map((item) {
        final daysLeft = item.deadlineDatetime.difference(now).inDays;

        return ListTile(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item.image.startsWith("assets")
                    ? Image.asset(item.image, height: 70, width: 70)
                    : Image.network(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                        height: 70,
                        width: 70),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
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
                                fontSize: 15,
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
                                  ' ${dateFormat.format(item.deadlineDatetime)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                // const Text(
                                //   ' あと',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //   ),
                                // ),
                                // Text(
                                //   '$daysLeft日',
                                //   style: const TextStyle(
                                //     fontSize: 15,
                                //     color: Colors.red,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
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
        );
      }),
    ];

    return ListView(
      padding: const EdgeInsets.all(0),
      children: combinedList,
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
