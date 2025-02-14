// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:nearsq/common/widgets/custom_shapes/containers/primary_header_container.dart';
// import 'package:nearsq/common/widgets/custom_shapes/containers/search_container.dart';
// import 'package:nearsq/common/widgets/layouts/grid_layout.dart';
// import 'package:nearsq/common/widgets/products/product_cards/product_card_vertical.dart';
// import 'package:nearsq/common/widgets/texts/sections_heading.dart';
// import 'package:nearsq/features/nearsq/screens/home/widgets/home_appbar.dart';
// import 'package:nearsq/features/nearsq/screens/home/widgets/home_categories.dart';
// import 'package:nearsq/features/nearsq/screens/home/widgets/promo_slider.dart';
// import 'package:nearsq/navigation_drawer_widget.dart';
// import 'package:nearsq/utilis/constants/image_strings.dart';
// import 'package:nearsq/utilis/constants/sizes.dart';






// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return   Scaffold(
//       drawer: NavigationDrawerWidget(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
            
            
//               const TPrimaryHeaderContainer(
                
//                child:  Column(
//                 children: [
//                   THomeAppBar(),
//                    SizedBox(height: TSizes.spaceBtwSections,),
//                   TSearchContainer(
//                     text: 'Search in nearsq',
//                     icon: Iconsax.search_normal,
//                   ),
//                   SizedBox(height: TSizes.spaceBtwSections,),
//                   Padding(padding: 
//                   EdgeInsets.only(left: TSizes.defaultSpace,),
//                   child: Column(
//                     children: [
//                       TSectionHeading(
//                         title: 'Popular Categories',
//                         showActionButton: false,
//                         textColor: Colors.white,
//                       ),
//                       SizedBox(height: TSizes.spaceBtwItems,),

//                       //categories
//                       THomeCategories(),
                    
//                     ],
//                   ),

//                   ),
//                   SizedBox(height: TSizes.spaceBtwSections,)

//                 ],
//               ),
//             ),
//              Padding(
//                padding: const EdgeInsets.all(TSizes.defaultSpace),
//                child: Column(
//                  children: [
//                     const TPromoSlider(
//                     banners: [ TImages.promoBanner1,TImages.promoBanner2, TImages.promoBanner3,],),
//                      const SizedBox(height: TSizes.spaceBtwSections,),
//                      //heading
//                      TSectionHeading(
//                        title: 'Popular Products',
//                        onPressed: () {},
//                        ),
//                        const SizedBox(height: TSizes.spaceBtwItems,),
//                     //Popular Products
//                       TGridLayout(
//                         itemCount: 4,
//                         itemBuilder: (_, index) => const TProductCardVertical(),
//                       ),
                    
//                  ],
//                ),
//              ),
            
//           ],
//         ),

//       )
//       );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:nearsq/firebase_options.dart';
// import 'firebase_options.dart';
import 'package:rxdart/rxdart.dart';

class SOSRequest {
  final LatLng location;
  final String msg;
  final String name;
  final String phone;
  final String timestamp;

  SOSRequest({
    required this.location,
    required this.msg,
    required this.name,
    required this.phone,
    required this.timestamp,
  });
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController<void> get _rebuildStream => StreamController<void>();
  
  // Define the data points correctly
  final List<WeightedLatLng> data = [
    // High severity areas
    WeightedLatLng(LatLng(9.9312, 76.2673), 100.0), // Fort Kochi
    WeightedLatLng(LatLng(9.9894, 76.2956), 90.0),  // Vypeen
    WeightedLatLng(LatLng(9.9816, 76.2999), 85.0),  // Bolgatty
    
    // Medium severity areas
    WeightedLatLng(LatLng(9.9657, 76.2421), 60.0),  // Mattancherry
    WeightedLatLng(LatLng(9.9671, 76.2858), 55.0),  // Willingdon Island
    WeightedLatLng(LatLng(9.9450, 76.3115), 50.0),  // Ernakulam South
    
    // Low severity areas
    WeightedLatLng(LatLng(9.9816, 76.3234), 30.0),  // Kaloor
    WeightedLatLng(LatLng(9.9975, 76.3089), 25.0),  // Edappally
    WeightedLatLng(LatLng(9.9339, 76.3142), 20.0),  // Thevara
  ];

  // Define sharp color boundaries without transitions
  final Map<double, MaterialColor> gradients = {
    0.0: Colors.green,     // Safe areas (0-0.33)
    0.34: Colors.yellow,   // Warning areas (0.34-0.66)
    0.67: Colors.red,      // Danger areas (0.67-1.0)
  };

  int index = 0;

  String _selectedLayer = 'Both'; // Default to show both layers
  final List<String> _layerOptions = ['Both', 'Heatmap Only', 'Markers Only'];

  // Add this method to fetch online SOS requests
  Stream<List<SOSRequest>> _getOnlineSOSRequests() {
    return FirebaseFirestore.instance
        .collection('sos')
        .doc('online')
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        print('Online document does not exist');
        return [];
      }

      try {
        final data = doc.data();
        if (data == null) return [];

        final sosArray = data['sos'] as List?;
        if (sosArray == null) return [];

        return sosArray.where((sosData) {
          try {
            final lat = double.tryParse(sosData['lat'].toString());
            final lon = double.tryParse(sosData['lon'].toString());
            return lat != null && lon != null;
          } catch (e) {
            print('Invalid location data in online: $e');
            return false;
          }
        }).map<SOSRequest>((sosData) {
          return SOSRequest(
            location: LatLng(
              double.parse(sosData['lat'].toString()),
              double.parse(sosData['lon'].toString()),
            ),
            msg: sosData['msg']?.toString() ?? 'No message',
            name: sosData['name']?.toString() ?? 'No name',
            phone: sosData['phone']?.toString() ?? 'No phone',
            timestamp: sosData['timestamp']?.toString() ?? 'No timestamp',
          );
        }).toList();
      } catch (e) {
        print('Error processing online document: $e');
        return [];
      }
    });
  }

  // Rename existing _getSOSRequests to _getOfflineSOSRequests
  Stream<List<SOSRequest>> _getOfflineSOSRequests() {
    return FirebaseFirestore.instance
        .collection('sos')
        .doc('offline')
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        print('Document does not exist');
        return [];
      }

      try {
        final data = doc.data();
        if (data == null) {
          print('Document data is null');
          return [];
        }

        final sosArray = data['sos'] as List?;
        if (sosArray == null) {
          print('SOS array is null');
          return [];
        }

        return sosArray.where((sosData) {
          // Filter out invalid data
          try {
            final lat = double.tryParse(sosData['lat'].toString());
            final lon = double.tryParse(sosData['lon'].toString());
            return lat != null && lon != null;
          } catch (e) {
            print('Invalid location data: $e');
            return false;
          }
        }).map<SOSRequest>((sosData) {
          // Convert valid data to SOSRequest
          return SOSRequest(
            location: LatLng(
              double.parse(sosData['lat'].toString()),
              double.parse(sosData['lon'].toString()),
            ),
            msg: sosData['msg']?.toString() ?? 'No message',
            name: sosData['name']?.toString() ?? 'No name',
            phone: sosData['phone']?.toString() ?? 'No phone',
            timestamp: sosData['timestamp']?.toString() ?? 'No timestamp',
                
          );
        }).toList();
      } catch (e) {
        print('Error processing document: $e');
        return [];
      }
    });
  }

  // Add this method to combine both streams
  Stream<List<SOSRequest>> _getAllSOSRequests() {
    return Rx.combineLatest2(
      _getOnlineSOSRequests(),
      _getOfflineSOSRequests(),
      (List<SOSRequest> online, List<SOSRequest> offline) {
        return [...online, ...offline];
      },
    );
  }

  void _showSOSDetails(BuildContext context, SOSRequest sos) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.red),
            const SizedBox(width: 8),
            const Text('SOS Request'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${sos.name}'),
            const SizedBox(height: 8),
            Text('Message: ${sos.msg}'),
            const SizedBox(height: 8),
            Text('Contact: ${sos.phone}'),
            const SizedBox(height: 8),
            Text(
              'Time: ${sos.timestamp.toString()}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add call functionality here
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kochi Disaster Severity Heatmap'),
        backgroundColor: Colors.red,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: DropdownButton<String>(
                value: _selectedLayer,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black),
                icon: const Icon(Icons.layers, color: Colors.white),
                underline: Container(),
                items: _layerOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLayer = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(9.9312, 76.2673),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          if (_selectedLayer == 'Both' || _selectedLayer == 'Heatmap Only')
            HeatMapLayer(
              heatMapDataSource: InMemoryHeatMapDataSource(data: data),
              heatMapOptions: HeatMapOptions(
                gradient: gradients,
                minOpacity: 1,
                radius: 90,
              ),
              reset: _rebuildStream.stream,
            ),
          if (_selectedLayer == 'Both' || _selectedLayer == 'Markers Only')
            StreamBuilder<List<SOSRequest>>(
              stream: _getAllSOSRequests(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('StreamBuilder error: ${snapshot.error}');
                  return const SizedBox(); // Return empty widget instead of Text
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final sosRequests = snapshot.data ?? [];
                print('Number of SOS requests: ${sosRequests.length}'); // Debug print

                if (sosRequests.isEmpty) {
                  print('No SOS requests found');
                }

                return MarkerLayer(
                  markers: sosRequests.map((sos) => Marker(
                    point: sos.location,
                    width: 30,
                    height: 30,
                    child: GestureDetector(
                      onTap: () => _showSOSDetails(context, sos),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  LatLng _offsetLatLng(LatLng original, int index) {
    // Create a small offset for markers with same coordinates
    // Each subsequent marker will be shifted slightly
    const double offsetBase = 0.0001; // About 11 meters
    double latOffset = (index % 3 - 1) * offsetBase;
    double lngOffset = ((index ~/ 3) % 3 - 1) * offsetBase;
    return LatLng(
      original.latitude + latOffset,
      original.longitude + lngOffset,
  );
  }
}

















