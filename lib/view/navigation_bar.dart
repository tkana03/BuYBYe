import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/floating_button.dart';
import 'package:flutter_application_1/view/item_list_screen/screen.dart';
import 'package:flutter_application_1/view/main_screen/screen.dart';
import 'package:flutter_application_1/view/wish_list_item_screen/screen.dart';
import 'package:flutter_application_1/view/read_receipt_screen/screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatationWidgetPageIndexFormProvider = StateProvider<int>((ref) => 0);

class NavigationWidget extends ConsumerWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = ref.watch(navigatationWidgetPageIndexFormProvider);

    final ThemeData theme = Theme.of(context);
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
          // currentPageIndex.value = index;
          ref.read(navigatationWidgetPageIndexFormProvider.notifier).state =
              index;
        },
        selectedIndex: currentPageIndex,
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
      ][currentPageIndex],
    );
  }
}
