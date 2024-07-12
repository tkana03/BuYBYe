import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/insert_dummy_data_button.dart';
import 'package:flutter_application_1/model/isar_repository.dart';
import 'package:flutter_application_1/provider/item_provider.dart';
import 'package:flutter_application_1/provider/shop_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:background_task/background_task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// List<String> shopLocationList = [];
List<LatLng> shopLocationListDefined = [
  LatLng(30, 140),
  LatLng(40, 150),
  LatLng(50, 160),
];

class LatLng {
  LatLng(this.lat, this.lng);

  double lat;
  double lng;

  bool withinErrors(LatLng other) {
    final latAngle1 = lat.truncate();
    final latMinute1 = ((lat - latAngle1) * 60).truncate();
    final latSecond1 = (lat - latAngle1 - latMinute1 / 60) * 3600;

    final latAngle2 = other.lat.truncate();
    final latMinute2 = ((other.lat - latAngle2) * 60).truncate();
    final latSecond2 = (other.lat - latAngle2 - latMinute2 / 60) * 3600;

    final latSecondDiff = (latSecond1 - latSecond2).abs();
    final latOK = latAngle1 == latAngle2 && latMinute1 == latMinute2 && latSecondDiff < 3.75;

    final lngAngle1 = lng.truncate();
    final lngMinute1 = ((lng - lngAngle1) * 60).truncate();
    final lngSecond1 = (lng - lngAngle1 - lngMinute1 / 60) * 3600;

    final lngAngle2 = other.lng.truncate();
    final lngMinute2 = ((other.lng - lngAngle2) * 60).truncate();
    final lngSecond2 = (other.lng - lngAngle2 - lngMinute2 / 60) * 3600;

    final lngSecondDiff = (lngSecond1 - lngSecond2).abs();

    final lngOK = latOK && lngAngle1 == lngAngle2 && lngMinute1 == lngMinute2 && lngSecondDiff < 5.625;

    return latOK && lngOK;
  }
}

// バックグラウンドで位置情報を受け取り，データベース（Isar）に保存する
@pragma('vm:entry-point')
void backgroundHandler(Location data) {
  debugPrint('backgroundHandler: ${DateTime.now()}, $data');
  // if (shopLocationList.isNotEmpty) {
  //   for (var shop in shopLocationList) {
  //     debugPrint('address: $shop');
  //   }
  // } else {
  //   debugPrint('shopLocationList is empty');
  // }

  if (shopLocationListDefined.isNotEmpty) {
    final other = LatLng(data.lat ?? 0, data.lng ?? 0);
    for (var location in shopLocationListDefined) {
      // debugPrint('address: $shop');
      if (location.withinErrors(other)) {
        debugPrint('250m以内: ${location.lat}, ${location.lng}');
      }
    }
  } else {
    debugPrint('shopLocationListDefined is empty');
  }

  // Future(() async {
  //   // debugPrint('backgroundHandler: ${DateTime.now()}, $data');
  //   await IsarRepository.configure();
  //   final shops = await IsarRepository.isar.shops.where().findAll();

  //   for (var shop in shops) {
  //     debugPrint("name: ${shop.name} address: ${shop.address}");
  //   }
  //   IsarRepository.isar.writeTxnSync(() {
  //     final latLng = LatLng()
  //       ..lat = data.lat ?? 0
  //       ..lng = data.lng ?? 0;
  //     IsarRepository.isar.latLngs.putSync(latLng);
  //   });
  // });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundTask.instance.setBackgroundHandler(backgroundHandler);
  await BackgroundTask.instance.start();
  runApp(const ProviderScope(child: MyApp()));
  //await IsarRepository.configure();
  //await initializeDateFormatting('ja_JP');

  // runApp(const MyApp(isar: isar));
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class ShopList extends ConsumerWidget {
  const ShopList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if (shopLocationList.isEmpty) {
    //   () async {
    //     final shops = await ref.read(shopNotifierProvider.notifier).getShops();
    //     for (var shop in shops) {
    //       shopLocationList.add(shop.address);
    //     }
    //   }();
    // }

    final shops = ref.watch(shopNotifierProvider);
    final items = ref.watch(itemNotifierProvider);

    // フィルタリング
    // filteredItems = ...

    return Column(children: [
      const ShopDummyInsertButton(),
      Expanded(
          child: ListView.builder(
        // data: (shops) => ListView.builder(
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
              // Text('アイテム３テスト'),
              Text(shops[index].name),
            ],
          ));
        },
      )),
      const ItemDummyInsertButton(),
      Expanded(
          child: ListView.builder(
              // data: (shops) => ListView.builder(
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
                    // Text('アイテム３テスト'),
                    Text(items[index].name),
                  ],
                ));
              }))
    ]);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final items = List<String>.generate(100, (i) => "Item $i");

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: const [
            Icon(Icons.add),
            Icon(Icons.share),
          ]),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Container(
          color: Colors.grey,
          child: const Padding(
            padding: EdgeInsets.all(32),
            child: ShopList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
