import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/isar_repository.dart';
import 'package:flutter_application_1/provider/item_provider.dart';
import 'package:flutter_application_1/schema/items.dart';
import 'package:flutter_application_1/view/main_screen/screen.dart';
import 'package:flutter_application_1/view/navigation_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class ReceiptItem {
  String? name;
  int? price;
  String? status;
  String? purchase;
  String? deadline;
  String? image = "assets/items/001_95㎜_348g.png";
  String? category;

  bool isChecked = false;

  String get nameX => name!;
  int get priceX => price!;
  String get statusX => status!;
  String get categoryX => category!;
  String get imageX => image!;
  DateTime get deadlineDatetime => DateTime.parse(deadline!);
  DateTime get purchaseDatetime => DateTime.parse(purchase!);
}

class RegisterItemState extends StateNotifier<List<ReceiptItem>> {
  RegisterItemState(super.initialItems);

  String _getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case '常温':
        return '冷蔵';
      case '冷蔵':
        return '冷凍';
      case '冷凍':
        return '常温';
      default:
        return '常温'; // デフォルト値を設定
    }
  }

  void toggleStatus(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i]..status = _getNextStatus(state[i].statusX)
        else
          state[i],
    ];
  }

  void checkItem(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i]..isChecked = !state[i].isChecked else state[i],
    ];
  }

  Future<void> addItem(String name, int price, String status) async {
    final item = ReceiptItem()
      ..name = name
      ..price = price
      ..status = status
      ..category = "食料品"
      ..image = "assets/items/001_187mm_95g.png"
      ..deadline = "2025-01-15"
      ..purchase = "2024-07-13";

    state = [...state, item];
  }

  Future<void> insertItemToDB(WidgetRef ref) async {
    debugPrint("insertItemToDB: state.length = ${state.length}");

    final fmtItems = [];
    for (var item in state) {
      final fmtItem = Item(
        id: Isar.autoIncrement,
        name: item.nameX,
        state: item.statusX,
        // price: item.priceX,
        category: item.categoryX,
        deadline: item.deadline!,
        purchaseDate: item.purchase!,
        image: item.imageX,
      );
      fmtItems.add(fmtItem);
      debugPrint(fmtItem.toString());
    }

    // 他で使っているプロバイダでDBに書き込む（他のref.watchに反映させるため）
    for (var fmtItem in fmtItems) {
      ref.watch(itemNotifierProvider.notifier).insertItem(fmtItem);
    }
  }
}

final registerItemProvider =
    StateNotifierProvider<RegisterItemState, List<ReceiptItem>>(
  (ref) => RegisterItemState(
    [
      ReceiptItem()
        ..name = "アルフォート　ミニチョコレート"
        ..price = 98
        ..status = "冷蔵"
        ..category = "食料品"
        ..deadline = "2025-03-31"
        ..image = "assets/items/008_157mm_50g.png"
        ..purchase = "2024-07-13",
      ReceiptItem()
        ..name = "ホイップ植物性脂肪"
        ..price = 178
        ..status = "冷蔵"
        ..category = "食料品"
        ..deadline = "2024-07-21"
        ..image = "assets/items/003_3mm_4g.png"
        ..purchase = "2024-07-13",
      ReceiptItem()
        ..name = "ガーナ　ブラック"
        ..price = 324
        ..status = "冷蔵"
        ..category = "食料品"
        ..deadline = "2024-08-21"
        ..image = "assets/items/008_157mm_50g.png"
        ..purchase = "2024-07-13",
      // * 最後のデータはデモの追加用
      // Item()
      //   ..name = "大阪王将　羽付き餃子"
      //   ..price = 188
      //   ..status = "冷凍"
      //   ..category = "食料品"
      //   ..deadline = "2025-1-15"
      //   ..purchase = "2024-7-13",
    ],
  ),
);

final showAddItemFormProvider = StateProvider<bool>((ref) => false);

class RegisterItemScreen extends HookConsumerWidget {
  RegisterItemScreen({super.key});

  final itemStatusProvider = StateProvider<String>((ref) => "常温");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(registerItemProvider);
    final showAddItemForm = ref.watch(showAddItemFormProvider);
    final itemStatus = ref.watch(itemStatusProvider);

    final itemNameController = useTextEditingController();
    final itemPriceController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset("assets/logo/logo.png"),
        ),
        title: SizedBox(
          height: 45,
          child: Image.asset("assets/logo_text/logo_text_v1.png"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              '前回購入したものと同じものがあります\n前回購入したものを削除しますか？',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                const Text('前回の記録を削除'),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (value) {
                        ref
                            .read(registerItemProvider.notifier)
                            .checkItem(index);
                      },
                    ),
                    title: Row(children: [
                      Expanded(
                        //child: Scrollbar(
                        ///isAlwaysShown: false,
                        // controller: _scrollController,
                        // thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            item.nameX,
                            //overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // ),
                      SizedBox(width: 50, child: Text("¥${item.priceX}")),
                    ]),
                    trailing: ElevatedButton(
                      onPressed: () => ref
                          .read(registerItemProvider.notifier)
                          .toggleStatus(index),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 40),
                        backgroundColor: _getStatusColor(item.statusX),
                      ),
                      child: Text(item.statusX),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            if (showAddItemForm) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: itemNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '商品名',
                        prefixIcon: Icon(Icons.shop),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: itemPriceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '値段',
                        prefixIcon: Icon(Icons.shop),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String status = "";
                        if (itemStatus == "常温") {
                          status = "冷蔵";
                        } else if (itemStatus == "冷蔵") {
                          status = "冷凍";
                        } else if (itemStatus == "冷凍") {
                          status = "常温";
                        }
                        ref.read(itemStatusProvider.notifier).state = status;
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 40),
                        backgroundColor: _getStatusColor(itemStatus),
                      ),
                      child: Text(itemStatus),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = itemNameController.text;
                        int price;
                        try {
                          price = int.parse(itemPriceController.text == ""
                              ? "0"
                              : itemPriceController.text);
                        } catch (e) {
                          debugPrint(e.toString());
                          price = 0;
                        }
                        ref
                            .read(registerItemProvider.notifier)
                            .addItem(name, price, itemStatus);
                        ref.read(showAddItemFormProvider.notifier).state =
                            false;
                      },
                      child: const Text('登録'),
                    ),
                  ],
                ),
              ),
            ],
            Center(
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(showAddItemForm ? Icons.remove : Icons.add),
                    label: const Text('再撮影'),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton.icon(
                    onPressed: () {
                      ref.read(showAddItemFormProvider.notifier).state =
                          !showAddItemForm;
                    },
                    icon: Icon(showAddItemForm ? Icons.remove : Icons.add),
                    label: const Text('商品追加'),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .watch(registerItemProvider.notifier)
                          .insertItemToDB(ref);

                      // トップ画面を指定
                      ref
                          .watch(
                              navigatationWidgetPageIndexFormProvider.notifier)
                          .state = 3;
                      // ignore: use_build_context_synchronously
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NavigationWidget()));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text('確定'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case '常温':
        return Colors.green;
      case '冷蔵':
        return Colors.blue;
      case '冷凍':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}
