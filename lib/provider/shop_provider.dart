import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/provider/isar_provider.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class ShopNotifier extends StateNotifier<List<Shop>> {
  ShopNotifier(this.ref) : super([]) {
    _initialize();
  }

  final Ref ref;
  late final Isar isar;

  Future<void> _initialize() async {
    isar = await ref.read(isarProvider.future);
    await _registerShops();
    state = await getShops();
  }

  /// 初期データの登録
  Future<void> _registerShops() async {
    final oldShops = await getShops();
    if (oldShops.isNotEmpty) {
      return;
    }

    try {
      final bytes = await rootBundle.load('assets/shops.json');
      final jsonStr = const Utf8Decoder().convert(bytes.buffer.asUint8List());
      final json = jsonDecode(jsonStr) as List;

      // jsonのパース
      final shops = <Shop>[];
      json.asMap().forEach((int i, dynamic e) {
        shops.add(Shop(id: i + 1, name: e['name'], address: e['address']));
      });

      // 新規データの追加
      for (Shop shop in shops) {
        insertShop(shop);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Shop>> getShops() async {
    final shops = await isar.shops.where().findAll();
    debugPrint('getShops: ${shops.length}, ${shops.toString()}');
    return shops;
  }

  Future<void> insertShop(Shop shop) async {
    await isar.writeTxn(() => isar.shops.put(shop));
    state = [...state, shop];
  }
}

final shopNotifierProvider =
    StateNotifierProvider<ShopNotifier, List<Shop>>((ref) => ShopNotifier(ref));
