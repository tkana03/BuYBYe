import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItemNameField extends HookWidget {
  const ItemNameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isFocused = useState(false);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 300,
        child: Focus(
          onFocusChange: (hasFocus) {
            isFocused.value = hasFocus;
          },
          child: TextFormField(
            controller: controller,
            obscureText: false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '商品',
              prefixIcon: const Icon(Icons.shop),
              suffixIcon: isFocused.value ? const Icon(Icons.clear) : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '商品名を入力してください';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
