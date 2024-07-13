import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/shop_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ShopList(),
    );
  }
}
