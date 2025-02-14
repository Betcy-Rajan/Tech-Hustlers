import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearsq/features/users/Emergency/controllers/location_controller.dart';
import 'package:nearsq/features/personalization/models/user_models.dart';
import 'package:nearsq/common/widgets/appbar/appbar.dart';
import 'package:nearsq/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:nearsq/common/widgets/images/t_rounded_image.dart';
import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/features/users/Emergency/esp.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({Key? key}) : super(key: key);

  Future<UserModel> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'No user logged in';

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    return UserModel.fromSnapshot(doc);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final currentUser = snapshot.data!;
        final LocationController locationController = Get.put(
          LocationController(currentUser: currentUser)
        );

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TPrimaryHeaderContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      children: [
                        const TAppBar(),
                        Text(
                          "Emergency SOS",
                          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
                        ),
                        const TRoundedImage(
                          imageUrl: "images/logos/nearsq.png",
                          width: 250,
                          height: 200,
                        ),
                      ],
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'Send emergency SOS with your current location',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      
                      // Online SOS Button
                      Obx(() => locationController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 150,
                            width: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () async {
                                await locationController.getCurrentLocation();
                                await locationController.sendSOS();
                              },
                              child: Text(
                                "Online SOS",
                                style: Theme.of(context).textTheme.headlineLarge!.apply(color: Colors.white)
                              ),
                            ),
                          )
                      ),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),
                      
                      // Offline SOS Button
                      // Obx(() => locationController.isLoading.value
                      //   ? const CircularProgressIndicator()
                      //   : SizedBox(
                      //       height: 150,
                      //       width: 250,
                      //       child: SendESP(
                      //         location: LatLng(
                      //           locationController.latitude.value,
                      //           locationController.longitude.value
                      //         ),
                      //       ),
                      //     )
                      // ),
                      Obx(() => locationController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 150,
                            width: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () async {
                                await locationController.getCurrentLocation();
                                SendESP(
                              location: LatLng(
                                locationController.latitude.value,
                                locationController.longitude.value
                              ),
                            );

                                
                              },
                              child: Text(
                                "Offline SOS",
                                style: Theme.of(context).textTheme.headlineLarge!.apply(color: Colors.white)
                              ),

                               
                            ),
                            
                          )
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Obx(() => Text(
                        'Location: ${locationController.latitude.value}, ${locationController.longitude.value}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}