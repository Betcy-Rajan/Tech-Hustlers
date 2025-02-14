import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check and request location permissions
  Future<LocationPermission> checkAndRequestPermissions() async {
    bool isEnabled = await isLocationEnabled();
    if (!isEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return permission;
  }

  // Get the current location of the user
  Future<Position> getCurrentLocation() async {
    await checkAndRequestPermissions();
    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Stream live location updates
  // Stream<Position> getLiveLocation() {
  //   return Geolocator.getPositionStream(
  //     locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
  //     distanceFilterMeters: 10, // Update location every 10 meters
  //   );
  // }
}