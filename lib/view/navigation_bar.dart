import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/item_list_screen/screen.dart';
import 'package:flutter_application_1/view/main_screen/screen.dart';
import 'package:flutter_application_1/view/read_receipt_screen/receipt_item.dart';
import 'package:flutter_application_1/view/wish_list_item_screen/screen.dart';
import 'package:flutter_application_1/view/read_receipt_screen/screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavigationWidget extends HookWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = useState(0);

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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          currentPageIndex.value = index;
        },
        selectedIndex: currentPageIndex.value,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt),
            label: '買いたい',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt),
            label: 'レシート登録',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: '在庫一覧',
          ),
          // ![for debug] カメラ撮影後の遷移先（シミュレータでカメラを起動できないため、これをスキップしたもの）
          // NavigationDestination(
          //   icon: Icon(Icons.add),
          //   label: '[dev]',
          // ),
        ],
      ),
      body: <Widget>[
        /// top page
        const MainScreen(),

        /// wish list page
        const WishListItemScreen(),

        /// read receipt page
        const ReadReceiptScreen(),

        // item list page
        const ItemListScreen(),

        // ![for debug] カメラ撮影後の遷移先（シミュレータでカメラを起動できないため、これをスキップしたもの）
        // RegisterItemScreen(),
      ][currentPageIndex.value],
    );
  }
}
