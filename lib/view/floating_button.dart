import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/read_receipt_screen/screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FloatingButton extends HookWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ReadReceiptScreen()));
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
