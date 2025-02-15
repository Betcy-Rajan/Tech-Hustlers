// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// import 'package:nearsq/features/Camp/controllers/camp_controller.dart';
// import 'package:nearsq/features/Camp/models/camp_models.dart';

// class CampScreen extends StatelessWidget {
//   final CampController _campController = Get.put(CampController());
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _peopleController = TextEditingController();
//   final TextEditingController _resourcesController = TextEditingController();

//   CampScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('nearsQ'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           // Map
//           // Expanded(
//           //   flex: 2,
//           //   child: MapWidget(
              
//           //     cameraOptions: CameraOptions(
//           //       center: Point(
//           //         coordinates: Position(
//           //           0, // Longitude
//           //           0, // Latitude
//           //         ),
//           //       ),
//           //       zoom: 2, // Initial zoom level
//           //     ),
//           //     onMapCreated: (MapboxMap mapboxMap) {
//           //       // Add markers for camps
//           //       for (var camp in _campController.camps) {
//           //         mapboxMap.annotations.createPointAnnotationManager().then((manager) {
//           //           manager.create(
//           //             PointAnnotationOptions(
//           //               geometry: Point(
//           //                 coordinates: Position(
//           //                   ,
//           //                   camp.latitude,
//           //                 ),
//           //               ),
//           //               iconImage: 'marker-icon', // Use a custom icon
//           //               textField: camp.name,
//           //             ),
//           //           );
//           //         });
//           //       }
//           //     },
//           //   ),
//           // ),
//           // Camp Details Form
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(labelText: 'Camp Name'),
//                 ),
//                 TextField(
//                   controller: _peopleController,
//                   decoration: InputDecoration(labelText: 'People Admitted'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: _resourcesController,
//                   decoration: InputDecoration(labelText: 'Deficient Resources'),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     final camp = Camp(
//                       id: '', // Firestore will generate the ID
//                       name: _nameController.text,
//                       peopleAdmitted: int.tryParse(_peopleController.text) ?? 0,
//                       deficientResources: _resourcesController.text,
//                    // Replace with actual longitude
//                     );
//                     _campController.addCamp(camp);
//                   },
//                   child: Text('Add Camp'),
//                 ),
//               ],
//             ),
//           ),
//           // List of Camps
//           Expanded(
//             flex: 1,
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: _campController.camps.length,
//                 itemBuilder: (ctx, index) {
//                   final camp = _campController.camps[index];
//                   return ListTile(
//                     title: Text(camp.name),
//                     subtitle: Text('People Admitted: ${camp.peopleAdmitted}\nDeficient Resources: ${camp.deficientResources}'),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/features/Camp/controllers/camp_controller.dart';
import 'package:nearsq/features/Camp/models/camp_models.dart';
import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/utilis/validators/validation.dart';

class CampScreenOfficial extends StatelessWidget {
  final CampController _campController = Get.put(CampController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch camps when the screen loads
    _campController.fetchCamps();

    return Scaffold(
      appBar: AppBar(
        title: Text('nearsQ'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by location...',
                
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Trigger search when icon is clicked
                    _campController.searchCampsByLocation(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                // Also trigger search when user presses enter
                _campController.searchCampsByLocation(value);
              },
            ),
          ),
          // Form Section
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Form(
              key: _campController.campFormKey,
              child: Column(
                children: [
                  // Camp Name
                  TextFormField(
                    controller: _nameController,
                    validator: (value) => TValidator.validateEmptyText(value, 'Camp Name'),
                    decoration: const InputDecoration(
                      hintText: 'Camp Name',
                      prefixIcon: Icon(Iconsax.home), // Use appropriate icon
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // People Admitted
                  TextFormField(
                    controller: _peopleController,
                    validator: (value) => TValidator.validateEmptyText(value, 'People Admitted'),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'People Admitted',
                      prefixIcon: Icon(Iconsax.people), // Use appropriate icon
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Deficient Resources
                  TextFormField(
                    controller: _locationController,
                    validator: (value) => TValidator.validateEmptyText(value, 'location'),
                    decoration: const InputDecoration(
                      hintText: 'Location',
                      prefixIcon: Icon(Iconsax.warning_2), // Use appropriate icon
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final camp = Camp(
                          id: '', // Firestore will generate the ID
                          name: _nameController.text,
                          peopleAdmitted: int.tryParse(_peopleController.text) ?? 0,
                          location: _locationController.text,
                        );
                        _campController.addCamp(camp);
                        _nameController.clear();
                        _peopleController.clear();
                        _locationController.clear();
                      },
                      child: Text('Add Camp'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final campsToShow = _campController.searchQuery.isEmpty 
                  ? _campController.camps 
                  : _campController.filteredCamps;

              if (campsToShow.isEmpty) {
                return Center(child: Text('No camps found'));
              }

              return ListView.builder(
                itemCount: campsToShow.length,
                itemBuilder: (ctx, index) {
                  final camp = campsToShow[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    color: Colors.blue.shade50, // Light blue background for the tile
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        camp.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900, // Dark blue text for the title
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'People Admitted: ${camp.peopleAdmitted}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700, // Grey text for people admitted
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Location ${camp.location}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700, // Grey text for deficient resources
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          Get.defaultDialog(
                            title: 'Delete Camp',
                            content: Text('Are you sure you want to delete ${camp.name}?'),
                            textConfirm: 'Delete',
                            textCancel: 'Cancel',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              _campController.deleteCamp(camp.id);
                              Get.back(); // Close the dialog
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}