import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      Get.snackbar('Error', 'Unable to get location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadLocationToFirebase(String text) async {
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar('Error', 'Location not available');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('locations').add({
        'latitude': latitude.value,
        'longitude': longitude.value,
        'text': text,
        'timestamp': DateTime.now(),
      });
      Get.snackbar('Success', 'Location uploaded to Firebase');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload location: $e');
    }
  }
}