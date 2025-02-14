// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:nearsq/features/users/Emergency/controllers/location_controller.dart';
// import 'package:nearsq/features/personalization/models/user_models.dart';
// import 'package:nearsq/common/widgets/appbar/appbar.dart';
// import 'package:nearsq/common/widgets/custom_shapes/containers/primary_header_container.dart';
// import 'package:nearsq/common/widgets/images/t_rounded_image.dart';
// import 'package:nearsq/utilis/constants/sizes.dart';
// import 'package:nearsq/features/users/Emergency/esp.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:iconsax/iconsax.dart';

// class LocationScreen extends StatelessWidget {
//   LocationScreen({Key? key}) : super(key: key);

//   Future<UserModel> getCurrentUser() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw 'No user logged in';

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();
    
//     return UserModel.fromSnapshot(doc);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<UserModel>(
//       future: getCurrentUser(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ),
//           );
//         }

//         final currentUser = snapshot.data!;
//         final LocationController locationController = Get.put(
//           LocationController(currentUser: currentUser)
//         );

//         return Scaffold(
//           backgroundColor: Colors.grey[100],
//           appBar: AppBar(
//             backgroundColor: Colors.red,
//             title: const Text(
//               'Emergency SOS',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             centerTitle: true,
//             elevation: 0,
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Emergency Header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: const BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(30),
//                       bottomRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       const Icon(
//                         Iconsax.warning_2,
//                         size: 60,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         "In case of emergency,\nuse one of the options below",
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           color: Colors.white,
//                           height: 1.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // SOS Options
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       // Online SOS Card
//                       _buildSOSCard(
//                         context: context,
//                         title: "Online SOS",
//                         description: "Send emergency alert through internet",
//                         icon: Iconsax.wifi,
//                         color: Colors.blue,
//                         onTap: () async {
//                           await locationController.getCurrentLocation();
//                           await locationController.sendSOS();
//                         },
//                         isLoading: locationController.isLoading.value,
//                       ),

//                       const SizedBox(height: 20),

//                       // Offline SOS Card
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 8,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Obx(() => SendESP(
//                           location: LatLng(
//                             locationController.latitude.value,
//                             locationController.longitude.value
//                           ),
//                         )),
//                       ),

//                       const SizedBox(height: 30),

//                       // Location Display
//                       Container(
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               spreadRadius: 1,
//                               blurRadius: 5,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Obx(() => Column(
//                           children: [
//                             const Icon(
//                               Iconsax.location,
//                               color: Colors.blue,
//                               size: 30,
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               'Current Location',
//                               style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               '${locationController.latitude.value.toStringAsFixed(6)}, '
//                               '${locationController.longitude.value.toStringAsFixed(6)}',
//                               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                                 color: Colors.grey[600],
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         )),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSOSCard({
//     required BuildContext context,
//     required String title,
//     required String description,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//     required bool isLoading,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(15),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 30),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         description,
//                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (isLoading)
//                   const CircularProgressIndicator()
//                 else
//                   Icon(Icons.arrow_forward_ios, color: color),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

class LocationScreen extends StatefulWidget {
  LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng currentLocation = LatLng(9.968166, 76.420864);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determinePosition();
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get the current position once
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

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
        final LocationController locationController =
            Get.put(LocationController(currentUser: currentUser));

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
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: Colors.white),
                      ),
                      const TRoundedImage(
                        imageUrl: "images/logos/nearsq.png",
                        width: 250,
                        height: 200,
                      ),
                    ],
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 20.0),
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
                                child: Text("Online SOS",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .apply(color: Colors.white)),
                              ),
                            )),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Offline SOS Button
                      Obx(() => locationController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 150,
                            width: 250,
                            
                            child: SendESP(
                              location: LatLng(
                                locationController.latitude.value,
                                locationController.longitude.value
                              ),
                            ),
                          )
                      ),
                      // Obx(() => locationController.isLoading.value
                      //     ? const CircularProgressIndicator()
                      //     :
                      //      SizedBox(
                      //         height: 150,
                      //         width: 250,
                      //         child: SendESP(location: currentLocation))),
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