// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:nearsq/features/Camp/models/camp_models.dart';

// class CampController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   var camps = <Camp>[].obs;

//   // Add a new camp to Firestore
//   Future<void> addCamp(Camp camp) async {
//     await _firestore.collection('camp').add(camp.toMap());
//     fetchCamps(); // Refresh the list
//   }

//   // Fetch camps from Firestore
//   Future<void> fetchCamps() async {
//     final snapshot = await _firestore.collection('camp').get();
//     camps.assignAll(snapshot.docs.map((doc) => Camp.fromMap(doc.id, doc.data())).toList());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nearsq/features/Camp/models/camp_models.dart';

class CampController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var camps = <Camp>[].obs;

  get campFormKey => null;

  // Add a new camp to Firestore
  Future<void> addCamp(Camp camp) async {
    await _firestore.collection('camp').add(camp.toMap());
    fetchCamps(); // Refresh the list
  }

  // Fetch camps from Firestore
  Future<void> fetchCamps() async {
    try {
      final snapshot = await _firestore.collection('camp').get();
      print('Fetched ${snapshot.docs.length} camps'); // Log the number of camps fetched
      camps.assignAll(snapshot.docs.map((doc) {
        print('Camp Data: ${doc.data()}'); // Log each camp's data
        return Camp.fromMap(doc.id, doc.data());
      }).toList());
    } catch (e) {
      print('Error fetching camps: $e'); // Log any errors
    }
  }
  Future<void> deleteCamp(String campId) async {
    try {
      await _firestore.collection('camp').doc(campId).delete();
      fetchCamps(); // Refresh the list after deletion
    } catch (e) {
      print('Error deleting camp: $e');
    }
  }
}