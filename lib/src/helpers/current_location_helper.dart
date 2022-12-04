import 'package:geolocator/geolocator.dart';

class LocationHelper {

  static Future<Position> getCurrentLocation() async {
  //    LocationPermission permission;
  //  permission = await Geolocator.requestPermission();
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
