class SexagesimalScale {
  SexagesimalScale(this.angle, this.minute, this.second);

  int angle;
  int minute;
  double second;

  static SexagesimalScale fromDecimalScale(double value) {
    if (value.isNaN || value.isInfinite) {
      return SexagesimalScale(0, 0, 0.0);
    }

    final angle = value.truncate();
    final minute = ((value - angle) * 60).truncate();
    final second = (value - angle - minute / 60) * 3600;

    return SexagesimalScale(angle, minute, second);
  }

  @override
  String toString() {
    return '$angle° $minute\' ${second.toStringAsFixed(2)}"';
  }
}

class LatLng {
  LatLng(this.lat, this.lng);

  double lat;
  double lng;

  bool withinErrors(LatLng other) {
    final lat60 = SexagesimalScale.fromDecimalScale(lat);
    final lng60 = SexagesimalScale.fromDecimalScale(lng);

    final otherLat60 = SexagesimalScale.fromDecimalScale(other.lat);
    final otherLng60 = SexagesimalScale.fromDecimalScale(other.lng);

    final isLatWithin = lat60.angle == otherLat60.angle &&
        lat60.minute == otherLat60.minute &&
        (lat60.second - otherLat60.second).abs() < 3.75;

    final isLngWithin = lng60.angle == otherLng60.angle &&
        lng60.minute == otherLng60.minute &&
        (lng60.second - otherLng60.second).abs() < 5.625;

    // final latAngle1 = lat.truncate();
    // final latMinute1 = ((lat - latAngle1) * 60).truncate();
    // final latSecond1 = (lat - latAngle1 - latMinute1 / 60) * 3600;

    // final latAngle2 = other.lat.truncate();
    // final latMinute2 = ((other.lat - latAngle2) * 60).truncate();
    // final latSecond2 = (other.lat - latAngle2 - latMinute2 / 60) * 3600;

    // final latSecondDiff = (latSecond1 - latSecond2).abs();
    // final latOK = latAngle1 == latAngle2 &&
    //     latMinute1 == latMinute2 &&
    //     latSecondDiff < 3.75;

    // final lngAngle1 = lng.truncate();
    // final lngMinute1 = ((lng - lngAngle1) * 60).truncate();
    // final lngSecond1 = (lng - lngAngle1 - lngMinute1 / 60) * 3600;

    // final lngAngle2 = other.lng.truncate();
    // final lngMinute2 = ((other.lng - lngAngle2) * 60).truncate();
    // final lngSecond2 = (other.lng - lngAngle2 - lngMinute2 / 60) * 3600;

    // final lngSecondDiff = (lngSecond1 - lngSecond2).abs();

    // final lngOK = latOK &&
    //     lngAngle1 == lngAngle2 &&
    //     lngMinute1 == lngMinute2 &&
    //     lngSecondDiff < 5.625;

    return isLatWithin && isLngWithin;
  }
}
