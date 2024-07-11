import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<void> _loadShops(Isar isar) async {
  try {
    final bytes = await rootBundle.load('assets/shops.json');
    final jsonStr = const Utf8Decoder().convert(bytes.buffer.asUint8List());
    final json = jsonDecode(jsonStr) as List;

    // jsonのパース
    final shops = <Shop>[];
    json.asMap().forEach((int i, dynamic e) {
      shops.add(Shop(id: i + 1, name: e['name'], address: e['address']));
    });
    final shopCollection = isar.collection<Shop>();

    // 過去データの削除
    final oldShops = await shopCollection.where().findAll();
    if (oldShops.isNotEmpty) {
      for (Shop oldShop in oldShops) {
        await shopCollection.delete(oldShop.id);
      }
    }
    // 新規データの追加
    isar.writeTxn(() async {
      await shopCollection.putAll(shops.toList());
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}

class ShopRepository {
  ShopRepository(this.isar) {
    isar.shops.watchLazy().listen((event) async {
      if (!isar.isOpen) {
        return;
      }

      if (_shopStreamController.isClosed) {
        return;
      }

      _shopStreamController.add(await getShops());
    });
  }

  final Isar isar;

  final _shopStreamController = StreamController<List<Shop>>.broadcast();
  Stream<List<Shop>> get shopStream => _shopStreamController.stream;

  void dispose() {
    _shopStreamController.close();
  }

  Future<List<Shop>> getShops() async {
    if (!isar.isOpen) {
      return [];
    }

    return isar.shops.where().findAll();
  }

  Future<void> addShop(Shop shop) async {
    if (!isar.isOpen) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.shops.put(shop);
    });
  }

  Future<void> deleteShop(Shop shop) async {
    if (!isar.isOpen) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.shops.delete(shop.id);
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();

  final isar =
      await Isar.open([ShopSchema], directory: dir.path, inspector: true);

  await _loadShops(isar);

  // runApp(const MyApp(isar: isar));
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});
  final Isar isar;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final shopRepository = ShopRepository(isar);

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
      home: MyHomePage(title: '', shopRepository: shopRepository),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.shopRepository});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final ShopRepository shopRepository;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final items = List<String>.generate(100, (i) => "Item $i");

  final shops = <Shop>[];

  @override
  void initState() {
    super.initState();
    widget.shopRepository.shopStream.listen((event) {
      setState(() {
        shops.clear();
        shops.addAll(event);
      });
    });

    () async {
      await widget.shopRepository.getShops();
    }();
  }

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
          actions: [
            Icon(Icons.add),
            Icon(Icons.share),
          ]),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ListView.builder(
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
                        SizedBox(width: 16),
                        // Text('アイテム３テスト'),
                        Text(shops[0].name),
                      ],
                    ),
                  );
                }),
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
