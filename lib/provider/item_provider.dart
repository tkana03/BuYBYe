import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/isar_repository.dart';
import 'package:flutter_application_1/schema/items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _registerItems();
    state = await getItems();
  }

  /// 初期データの登録
  Future<void> _registerItems() async {
    final oldShops = await getItems();
    if (oldShops.isNotEmpty) {
      return;
    }

    // この関数はIsarのデータベースがからの時のみ実行される
    // そのため、ダミーデータを書き換えたい場合は、isarをブラウザで開いて、[item] の中身を全て削除
    try {
      final bytes = await rootBundle.load('assets/items.json');
      final jsonStr = const Utf8Decoder().convert(bytes.buffer.asUint8List());
      final json = jsonDecode(jsonStr) as List;

      // jsonのパース
      final items = <Item>[];
      json.asMap().forEach((int i, dynamic e) {
        items.add(Item(
          id: i + 1,
          name: e['name'],
          state: e['state'],
          purchaseDate: e['purchaseDate'],
          deadline: e['deadline'],
          category: e['category'],
          image: e['image'],
        ));
      });
      
      // 新規データの追加
      for (Item item in items) {
        insertItem(item);
        //print(item.name);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Item>> getItems() async {
    final items = await IsarRepository.isar.items.where().findAll();
    debugPrint('getItems: ${items.length}, ${items.toString()}');
    return items;
  }

  Future<void> insertItem(Item item) async {
    await IsarRepository.isar
        .writeTxn(() => IsarRepository.isar.items.put(item));
    state = [...state, item];
  }
}

final itemNotifierProvider =
    StateNotifierProvider<ItemNotifier, List<Item>>((ref) => ItemNotifier());
