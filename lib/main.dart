import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/background_util.dart' as background_util;
import 'package:flutter_application_1/model/isar_repository.dart';
import 'package:flutter_application_1/view/navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DB
  await IsarRepository.configure();

  // ! [for debug] ローカルデータの削除
  await IsarRepository.deleteAllData();

  // GPS
  background_util.setupGpsBackgroundTask();
  // ローカル通知
  background_util.setupLocalNotification();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bUybyE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            minimumSize: const Size(200, 45),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Color.fromARGB(255, 244, 244, 244),
        )
      ),
      home: const NavigationWidget()
    );
  }
}
