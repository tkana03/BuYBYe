import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropdownButtonWidget extends HookConsumerWidget {
  const DropdownButtonWidget(
      {super.key, required this.handleSelected, required this.focusNode});

  final void Function(String) handleSelected;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(shopNotifierProvider);
    final dropdownValue = useState('選択してください');

    if (shops.isNotEmpty) {
      dropdownValue.value = shops.first.name;
    }

    return DropdownMenu<String>(
      focusNode: focusNode,
      width: 300,
      enableFilter: false,
      leadingIcon: const Icon(Icons.room),
      requestFocusOnTap: true,
      label: const Text('店舗'),
      onSelected: (value) {
        focusNode.unfocus();
        dropdownValue.value = value!;
        handleSelected(value);
      },
      dropdownMenuEntries: shops.map((Shop shop) {
        return DropdownMenuEntry<String>(
          value: shop.name,
          label: shop.name,
        );
      }).toList(),
    );
  }
}
