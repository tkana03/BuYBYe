import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/insert_dummy_data_button.dart';
import 'package:flutter_application_1/provider/item_provider.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopList extends ConsumerWidget {
  const ShopList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(shopNotifierProvider);
    final items = ref.watch(itemNotifierProvider);
    print(items);

    return Column(
      children: [
        const ShopDummyInsertButton(),
        Expanded(
          child: ListView.builder(
            itemCount: shops.length,
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
                    Text(shops[index].name),
                  ],
                ),
              );
            },
          ),
        ),
        const ItemDummyInsertButton(),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
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
                    Text(items[index].name),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
