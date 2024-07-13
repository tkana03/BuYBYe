import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/floating_button.dart';
import 'package:flutter_application_1/view/main_screen/screen.dart';
import 'package:flutter_application_1/view/read_receipt_screen/screen.dart';
import 'package:flutter_application_1/view/wish_list_item_screen/screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavigationWidget extends HookWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = useState(0);

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
            // icon: Badge(
            //   label: Text('2'),
            //   child: Icon(Icons.messenger_sharp),
            // ),
            icon: Icon(Icons.list_alt),
            label: '商品一覧',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const MainScreen(),

        /// Notifications page
        const WishListItemScreen(),
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Column(
        //     children: <Widget>[
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 1'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 2'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        const ReadReceiptScreen(),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex.value],
      //floatingActionButton: const FloatingButton(),
    );
  }
}
