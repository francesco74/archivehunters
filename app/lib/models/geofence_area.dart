class GeofenceArea {
  final int id;
  final double latitude;
  final double longitude;
  final double radius; // in meters

  GeofenceArea({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory GeofenceArea.fromJson(Map<String, dynamic> json) {
    return GeofenceArea(
      id: json['id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      radius: json['radius'].toDouble(),
    );
  }
}
