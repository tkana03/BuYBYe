import 'package:background_task/background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/isar_repository.dart';
import 'package:flutter_application_1/model/lat_lng.dart';
import 'package:flutter_application_1/model/shop_location.dart';
import 'package:flutter_application_1/schema/shops.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';

List<ShopLocation> shopLocationList = [];

/// GPS
void setupGpsBackgroundTask() async {
  // バックグラウンドで位置情報を受け取る
  BackgroundTask.instance.setBackgroundHandler(backgroundHandler);
  await BackgroundTask.instance.start();
}

@pragma('vm:entry-point')
void backgroundHandler(Location data) {
  Future(() async {
    debugPrint('backgroundHandler: ${DateTime.now()}, $data');
    final shops = await IsarRepository.isar.shops.where().findAll();

    for (var shop in shops) {
      final shopLocation = ShopLocation(shop);
      // 対象の店舗が増えた場合はリストに追加
      // バックグラウンド時は消える可能性もありそうなので、この関数が呼ばれるたびに追加するようにしている
      if (!shopLocationList.contains(shopLocation)) {
        shopLocationList.add(shopLocation);
      }
    }

    final other = LatLng(data.lat ?? 0, data.lng ?? 0);
    for (var shopLocation in shopLocationList) {
      if (shopLocation.latLng.withinErrors(other)) {
        debugPrint(
            '250m以内: ${shopLocation.shop.name} (${shopLocation.latLng.lat}, ${shopLocation.latLng.lng})');
        showLocalNotification(
          title: "近くのお店に買いたい商品があるようです！",
          message: shopLocation.shop.name,
        );
        break;
      }
    }
  });
}

/// ローカル通知
void setupLocalNotification() {
  FlutterLocalNotificationsPlugin()
    ..resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission()
    ..initialize(const InitializationSettings(
      // android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ));
}

void showLocalNotification({required String title, required String message}) {
  // const androidNotificationDetail = AndroidNotificationDetails(
  //     'channel_id', // channel Id
  //     'channel_name' // channel Name
  //     );
  const iosNotificationDetail = DarwinNotificationDetails();
  const notificationDetails = NotificationDetails(
    iOS: iosNotificationDetail,
    // android: androidNotificationDetail,
  );
  FlutterLocalNotificationsPlugin()
      .show(0, title, message, notificationDetails);
}
