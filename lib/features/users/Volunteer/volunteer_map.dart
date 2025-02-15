import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearsq/utilis/constants/colors.dart';


class VolunteerMap extends StatefulWidget {
  const VolunteerMap({super.key});

  @override
  State<VolunteerMap> createState() => _VolunteerMapState();
}

class _VolunteerMapState extends State<VolunteerMap> {
  final MapController _mapController = MapController();
  List<Marker> _volunteerMarkers = [];
  String _selectedDistrict = 'All';
  
  final List<String> _districts = [
    'All',
    'Ernakulam',
    'Thrissur',
    'Kottayam',
    'Alappuzha',
    'Thiruvananthapuram',
    'Kozhikode',
  ];

  @override
  void initState() {
    super.initState();
    _loadVolunteers();
  }

  Future<void> _loadVolunteers() async {
    Query query = FirebaseFirestore.instance.collection('volunteers')
        .where('isAvailable', isEqualTo: true);
    
    if (_selectedDistrict != 'All') {
      query = query.where('district', isEqualTo: _selectedDistrict);
    }

    final volunteers = await query.get();

    setState(() {
      _volunteerMarkers = volunteers.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final GeoPoint location = data['location'];
        return Marker(
          point: LatLng(location.latitude, location.longitude),
          width: 30,
          height: 30,
          child: GestureDetector(
            onTap: () => _showVolunteerDetails(data),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Map'),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedDistrict,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              items: _districts.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedDistrict = newValue;
                  });
                  _loadVolunteers(); // Reload volunteers when district changes
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(9.9312, 76.2673),
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: _volunteerMarkers),
              ],
            ),
          ),
          // Show count of volunteers
          
        ],
      ),
    );
  }

  void _showVolunteerDetails(Map<String, dynamic> volunteer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Volunteer Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${volunteer['name']}'),
            Text('Phone: ${volunteer['phone']}'),
            Text('District: ${volunteer['district']}'),
            Text('Skill: ${volunteer['skill']}'),
            Text('Address: ${volunteer['address']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
    ),
);
}
}
