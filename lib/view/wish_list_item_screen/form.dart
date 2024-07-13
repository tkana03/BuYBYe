import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_application_1/provider/wish_list_provider.dart';
import 'package:flutter_application_1/schema/wish_list_item.dart';
import 'package:flutter_application_1/view/wish_list_item_screen/dropdown.dart';
import 'package:flutter_application_1/view/wish_list_item_screen/text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

// ignore: must_be_immutable
class WishListItemForm extends HookConsumerWidget {
  WishListItemForm({super.key});

  // final TextFieldState _itemState = TextFieldState();
  final TextEditingController _controller = TextEditingController();
  String _dropdownValue = '選択してください';

  void _handleSelected(String data) {
    _dropdownValue = data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishListItems = ref.watch(wishListItemNotifierProvider);
    final shops = ref.watch(shopNotifierProvider);

    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
        const Text("買いたい商品を登録",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ItemNameField(controller: _controller),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        DropdownButtonWidget(handleSelected: _handleSelected),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onPressed: () async {
            if (_controller.text.isEmpty) {
              await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("エラー"),
                      content: const Text("商品名を入力してください"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"))
                      ],
                    );
                  });
              return;
            }
            if (_dropdownValue == '選択してください') {
              await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("エラー"),
                      content: const Text("ショップを選択してください"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"))
                      ],
                    );
                  });
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      '商品［${_controller.text}（$_dropdownValue）］が登録されました。')),
            );

            final targetShop =
                shops.firstWhere((e) => e.name == _dropdownValue);
            ref
                .watch(wishListItemNotifierProvider.notifier)
                .insertWishListItem(WishListItem(id: Isar.autoIncrement)
                  ..name = _controller.text
                  ..shop.value = targetShop);

            // リセット
            _controller.clear();
          },
          child: const Text('登録'),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
        wishListItems.isEmpty
            ? const Text('登録されている商品はありません')
            : Expanded(
                child: ListView.builder(
                  itemCount: wishListItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Image.network(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Text(wishListItems[index].name!),
                              const SizedBox(width: 16),
                              Text(
                                wishListItems[index].shop.value?.name ?? '',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
