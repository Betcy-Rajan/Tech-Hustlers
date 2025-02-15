import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerController extends GetxController {
  final volunteerFormKey = GlobalKey<FormState>();
  
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  
  final selectedDistrict = 'Ernakulam'.obs;
  final selectedSkill = 'Medical'.obs;
  final currentLocation = Rxn<LatLng>();

  final districts = [
    'Ernakulam',
    'Thrissur',
    'Kottayam',
    'Alappuzha',
    'Thiruvananthapuram',
    'Kozhikode',
  ];

  final skills = [
    'Medical',
    'Search and Rescue',
    'Transportation',
    'Communication',
    'First Aid',
    'Other'
  ];

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      currentLocation.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Could not get location: $e');
    }
  }

  Future<void> registerVolunteer() async {
    if (volunteerFormKey.currentState!.validate() && currentLocation.value != null) {
      try {
        await FirebaseFirestore.instance.collection('volunteers').add({
          'name': name.text,
          'phone': phoneNumber.text,
          'address': address.text,
          'district': selectedDistrict.value,
          'skill': selectedSkill.value,
          'location': GeoPoint(
            currentLocation.value!.latitude,
            currentLocation.value!.longitude,
          ),
          'registeredAt': FieldValue.serverTimestamp(),
          'isAvailable': true,
        });

        Get.snackbar('Success', 'Registration successful!');
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Registration failed: $e');
      }
    }
  }

  @override
  void onClose() {
    name.dispose();
    phoneNumber.dispose();
    address.dispose();
    super.onClose();
  }
}