import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';



import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class SOSRequest {
  final LatLng location;
  final String msg;
  final String name;
  final String url; // Changed from phone to url for scrap data
  final String
      source; // Add source to differentiate between online/offline/scrap
  RxString status = 'pending'.obs;  // Change to this format

  SOSRequest({
    required this.location,
    required this.msg,
    required this.name,
    required this.url,
    required this.source,
    String initialStatus = 'pending',
  }) {
    status.value = initialStatus;
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final rescuerController = Get.put(RescuerController());
  late DatabaseReference databaseRef;
  Timer? _locationTimer; // Keep this for the timer

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref();
  }

  // Remove these fields:
  // final _rescuerLocationNotifier = ValueNotifier<LatLng?>(null);
  // Timer? _locationTimer;
  // Position? _currentPosition;
  // LatLng? _rescuerLocation;
  // late DatabaseReference databaseRef;

  // Remove the static data points
  List<WeightedLatLng> _getHeatmapData(List<SOSRequest> requests) {
    List<WeightedLatLng> heatmapData = [];

    for (var request in requests) {
      // Assign weights based on status and source
      double weight = _getRequestWeight(request);

      heatmapData.add(WeightedLatLng(request.location, weight));
    }

    return heatmapData;
  }

  // Helper method to determine weight based on request properties
  double _getRequestWeight(SOSRequest request) {
    // Base weight
    double weight = 50.0;

    // Adjust weight based on status
    switch (request.status.value) {
      case 'pending':
        weight *= 2.0; // Higher weight for pending requests
        break;
      case 'responding':
        weight *= 1.5; // Medium weight for responding
        break;
      case 'rescued':
        weight *= 0.5; // Lower weight for rescued
        break;
    }

    // Adjust weight based on source
    switch (request.source) {
      case 'online':
        weight *= 1.2; // Higher priority for real-time requests
        break;
      case 'offline':
        weight *= 1.0; // Normal priority
        break;
      case 'scrap':
        weight *= 0.8; // Lower priority for scraped data
        break;
    }

    return weight;
  }

  // Keep the existing gradients
  final Map<double, MaterialColor> gradients = {
    0.0: Colors.green, // Safe areas (0-0.33)
    0.34: Colors.yellow, // Warning areas (0.34-0.66)
    0.67: Colors.red, // Danger areas (0.67-1.0)
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
            url: sosData['phone']?.toString() ?? '',
            source: 'online',
            initialStatus: sosData['status']?.toString() ?? 'pending',
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
            url: sosData['phone']?.toString() ?? '',
            source: 'offline',
            initialStatus: sosData['status']?.toString() ?? 'pending',
          );
        }).toList();
      } catch (e) {
        print('Error processing document: $e');
        return [];
      }
    });
  }

  // Add this method to fetch scrap SOS requests
  Stream<List<SOSRequest>> _getScrapSOSRequests() {
    return FirebaseFirestore.instance
        .collection('sos')
        .doc('scrap')
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        print('Scrap document does not exist');
        return [];
      }

      try {
        final data = doc.data();
        if (data == null) return [];

        final searchAndRescue = data['search_and_rescue'] as List?;
        if (searchAndRescue == null) return [];

        return searchAndRescue.where((sosData) {
          try {
            final lat = double.tryParse(sosData['lat'].toString());
            final lon = double.tryParse(sosData['lon'].toString());
            return lat != null && lon != null;
          } catch (e) {
            print('Invalid location data in scrap: $e');
            return false;
          }
        }).map<SOSRequest>((sosData) {
          return SOSRequest(
            location: LatLng(
              double.parse(sosData['lat'].toString()),
              double.parse(sosData['lon'].toString()),
            ),
            msg: sosData['message']?.toString() ?? 'No message',
            name: sosData['user']?.toString() ?? 'No name',
            url: sosData['url']?.toString() ?? '',
            source: 'scrap',
            initialStatus: sosData['status']?.toString() ?? 'pending',
          );
        }).toList();
      } catch (e) {
        print('Error processing scrap document: $e');
        return [];
      }
    });
  }

  // Add a stream to listen to status updates
  Stream<String?> _getStatusUpdates() {
    return databaseRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return data?['status'] as String?;
    });
  }

  // Update the _getAllSOSRequests method
  Stream<List<SOSRequest>> _getAllSOSRequests() {
    return rxdart.Rx.combineLatest4(
      _getOnlineSOSRequests(),
      _getOfflineSOSRequests(),
      _getScrapSOSRequests(),
      _getStatusUpdates(),
      (List<SOSRequest> online, List<SOSRequest> offline,
          List<SOSRequest> scrap, String? currentStatus) {
        final allRequests = [...online, ...offline, ...scrap];
        
        // Update status for matching request
        if (currentStatus != null) {
          for (var request in allRequests) {
            // Get the current location values from the database
            final dbLat = databaseRef.child('toLat').toString();
            final dbLon = databaseRef.child('toLon').toString();
            
            // Compare with more precision
            if (request.location.latitude.toStringAsFixed(6) == dbLat &&
                request.location.longitude.toStringAsFixed(6) == dbLon) {
              request.status.value = currentStatus;
            }
          }
        }
        
        return allRequests;
      },
    );
  }

  // Update the _updateSOSStatus method
  void _updateSOSStatus(SOSRequest sos, String newStatus) {
    databaseRef.set({
      'status': newStatus,
      'frLat': rescuerController.location.value?.latitude,
      'frLon': rescuerController.location.value?.longitude,
      'toLat': sos.location.latitude.toStringAsFixed(6),
      'toLon': sos.location.longitude.toStringAsFixed(6),
    }).then((_) {
      sos.status.value = newStatus;  // Update the reactive status
    });
  }

  // Update the _showSOSDetails method to use StatefulBuilder for real-time updates
  void _showSOSDetails(BuildContext context, SOSRequest sos) {
    showDialog(
      context: context,
      builder: (context) => Obx(() => AlertDialog(
        title: Row(
          children: [
            Icon(
              sos.source == 'scrap' ? Icons.crisis_alert : Icons.warning_amber,
              color: sos.source == 'scrap' ? Colors.blue : _getStatusColor(sos.status.value),
            ),
            const SizedBox(width: 8),
            Text(sos.source == 'scrap' ? 'Search and Rescue' : 'SOS Request'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sos.name.isNotEmpty) Text('User: ${sos.name}'),
            const SizedBox(height: 8),
            Text('Message: ${sos.msg}'),
            const SizedBox(height: 8),
            if (sos.source != 'scrap') ...[
              Row(
                children: [
                  Text('Status: '),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(sos.status.value),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusMessage(sos.status.value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (sos.source != 'scrap' && sos.status.value != 'rescued') ...[
            ElevatedButton(
              onPressed: () {
                _updateSOSStatus(sos, 'responding');
                _startLocationTracking(sos);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
              ),
              child: const Text('Respond'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateSOSStatus(sos, 'rescued');
                _stopLocationTracking();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Rescued'),
            ),
          ],
        ],
      )),
    );
  }

  // Add helper methods for status colors and messages
  Color _getStatusColor(String status) {
    switch (status) {
      case 'responding':
        return Colors.yellow[700]!;
      case 'rescued':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'responding':
        return 'Rescue team is on the way';
      case 'rescued':
        return 'Rescued';
      default:
        return 'Pending';
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied')));
      return false;
    }
    return true;
  }

  // Update _startLocationTracking method
  void _startLocationTracking(SOSRequest sos) async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    rescuerController.startTracking(sos);
  }

  void _stopLocationTracking() {
    rescuerController.stopTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NearsQ Heatmap'),
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
      body: StreamBuilder<List<SOSRequest>>(
        stream: _getAllSOSRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sosRequests = snapshot.data ?? [];
          final heatmapData = _getHeatmapData(sosRequests);

          return FlutterMap(
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
                  heatMapDataSource:
                      InMemoryHeatMapDataSource(data: heatmapData),
                  heatMapOptions: HeatMapOptions(
                    gradient: gradients,
                    minOpacity: 1,
                    radius: 90,
                  ),
                ),
              if (_selectedLayer == 'Both' || _selectedLayer == 'Markers Only')
                Obx(() => PolylineLayer(
                      polylines: [
                        if (rescuerController.routePoints.value != null)
                          Polyline(
                            points: rescuerController.routePoints.value!,
                            strokeWidth: 4,
                            color: Colors.blue,
                            strokeCap: StrokeCap.round,
                            strokeJoin: StrokeJoin.round,
                            isDotted: false,
                          ),
                      ],
                    )),
              if (_selectedLayer == 'Both' || _selectedLayer == 'Markers Only')
                StreamBuilder<DatabaseEvent>(
                  stream: databaseRef.onValue,
                  builder: (context, dbSnapshot) {
                    return MarkerLayer(
                      markers: [
                        ...List.generate(sosRequests.length, (index) {
                          final sos = sosRequests[index];
                          return Marker(
                            point: sos.location,
                            width: 30,
                            height: 30,
                            child: sos.source == 'scrap' 
                                ? GestureDetector( // Regular GestureDetector for scrap markers
                                    onTap: () => _showSOSDetails(context, sos),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.crisis_alert,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : Obx(() => GestureDetector( // Obx only for non-scrap markers
                                    onTap: () => _showSOSDetails(context, sos),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(sos.status.value),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.warning_amber,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  )),
                          );
                        }),
                        if (rescuerController.location.value != null)
                          Marker(
                            point: rescuerController.location.value!,
                            width: 30,
                            height: 30,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.directions_run,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
            ],
          );
        },
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

// Add this new class for location state management
class RescuerController extends GetxController {
  Rx<LatLng?> location = Rx<LatLng?>(null);
  Rx<List<LatLng>?> routePoints = Rx<List<LatLng>?>(null);
  Timer? _locationTimer;
  late DatabaseReference databaseRef;

  // Add your Mapbox access token
  final String _mapboxToken =
      'pk.eyJ1IjoiYW5hbmQxMDYiLCJhIjoiY2x1dXlwMGdiMGFnMjJxbW9jcWo2eXBjMCJ9.gBCavskm54ytN6xsD0CgXQ';

  RescuerController() {
    databaseRef = FirebaseDatabase.instance.ref();
  }

  Future<void> _updateRoute(LatLng rescuerLocation, LatLng sosLocation) async {
    final url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${rescuerLocation.longitude},${rescuerLocation.latitude};'
        '${sosLocation.longitude},${sosLocation.latitude}'
        '?alternatives=true'
        '&geometries=geojson'
        '&overview=full'
        '&steps=true'
        '&access_token=$_mapboxToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = RouteCoordinates.fromJson(data);
        routePoints.value = route.points;
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  void startTracking(SOSRequest sos) async {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final position = await Geolocator.getCurrentPosition();
        location.value = LatLng(position.latitude, position.longitude);

        await databaseRef.set({
          'frLat': position.latitude,
          'frLon': position.longitude,
          'toLat': sos.location.latitude,
          'toLon': sos.location.longitude,
          'status': 'responding'
        });

        // Update route
        if (location.value != null) {
          await _updateRoute(location.value!, sos.location);
        }
      } catch (e) {
        print('Error updating location: $e');
      }
    });
  }

  void stopTracking() async {
    _locationTimer?.cancel();
    await databaseRef.update({
      'status': 'rescued',
      'frLat': null,
      'frLon': null,
      'toLat': null,
      'toLon': null
    });
    location.value = null;
    routePoints.value = null;
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    super.onClose();
  }
}

// Add this class to handle route data
class RouteCoordinates {
  final List<LatLng> points;

  RouteCoordinates({required this.points});

  factory RouteCoordinates.fromJson(Map<String, dynamic> json) {
    final route = json['routes'][0];
    final coords = (route['geometry']['coordinates'] as List)
        .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
        .toList();
    return RouteCoordinates(points: coords);
  }
}