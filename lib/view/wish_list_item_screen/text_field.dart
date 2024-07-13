import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItemNameField extends HookWidget {
  const ItemNameField(
      {super.key, required this.controller, required this.focusNode});
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 300,
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          obscureText: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '商品',
            prefixIcon: Icon(Icons.shop),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '商品名を入力してください';
            }
            return null;
          },
          onTapOutside: (e) => focusNode.unfocus(),
        ),
      ),
    );
  }
}
