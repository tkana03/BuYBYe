import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/isar_repository.dart';
import 'package:flutter_application_1/schema/wish_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class WishListItemNotifier extends StateNotifier<List<WishListItem>> {
  WishListItemNotifier() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = await getWishListItems();
  }

  Future<List<WishListItem>> getWishListItems() async {
    final items = await IsarRepository.isar.wishListItems.where().findAll();
    for (WishListItem item in items) {
      item.shop.load(); // IsarLink の読み込み
    }
    debugPrint('getWishListItems: ${items.length}, ...');
    return items;
  }

  Future<void> insertWishListItem(WishListItem item) async {
    await IsarRepository.isar.writeTxn(() async {
      await IsarRepository.isar.wishListItems.put(item);
      await item.shop.save(); // IsarLink の保存
    });
    state = [...state, item];
  }
}

final wishListItemNotifierProvider =
    StateNotifierProvider<WishListItemNotifier, List<WishListItem>>(
        (ref) => WishListItemNotifier());
