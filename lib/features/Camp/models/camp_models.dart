class Camp {
  final String id;
  final String name;
  final int peopleAdmitted;
  final String deficientResources;
  // final double latitude;
  // final double longitude;

  Camp({
    required this.id,
    required this.name,
    required this.peopleAdmitted,
    required this.deficientResources,
    // required this.latitude,
    // required this.longitude,
  });

  // Convert Camp to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'peopleAdmitted': peopleAdmitted,
      'deficientResources': deficientResources,
      // 'latitude': latitude,
      // 'longitude': longitude,
    };
  }

  // Create Camp from a Map
  factory Camp.fromMap(String id, Map<String, dynamic> map) {
    return Camp(
      id: id,
      name: map['name'],
      peopleAdmitted: (map['peopleAdmitted'] as num).toInt(),
      // peopleAdmitted: map['peopleAdmitted'],
      deficientResources: map['deficientResources'],
      // latitude: map['latitude'],
      // longitude: map['longitude'],
    );
  }
}