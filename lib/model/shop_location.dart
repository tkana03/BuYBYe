import 'package:flutter_application_1/model/lat_lng.dart';
import 'package:flutter_application_1/schema/shops.dart';

class ShopLocation {
  ShopLocation(this.shop) {
    latLng = LatLng(shop.lat, shop.lng);
  }

  Shop shop;
  late LatLng latLng;
}
