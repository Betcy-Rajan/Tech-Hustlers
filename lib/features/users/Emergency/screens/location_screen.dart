import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearsq/features/users/Emergency/controllers/location_controller.dart';

class LocationScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Location and Upload to Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Enter some text'),
            ),
            SizedBox(height: 20),
            Obx(() => locationController.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await locationController.getCurrentLocation();
                      await locationController.uploadLocationToFirebase(
                          textController.text);
                    },
                    child: Text('Get Location and Upload to Firebase'),
                  )),
            SizedBox(height: 20),
            Obx(() => Text(
                  'Latitude: ${locationController.latitude.value}, Longitude: ${locationController.longitude.value}',
                )),
          ],
        ),
      ),
    );
  }
}