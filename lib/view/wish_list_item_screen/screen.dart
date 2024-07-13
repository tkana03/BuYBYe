import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/wish_list_item_screen/form.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WishListItemScreen extends HookWidget {
  const WishListItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WishListItemForm(),
      ),
    );
  }
}
