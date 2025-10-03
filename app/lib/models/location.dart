// models/location.dart
class Location {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String modelUrl; // URL for the TFLite model
  final String labelsUrl; // URL for the TFLite model

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.modelUrl,
    required this.labelsUrl,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      modelUrl: json['model_url'],
      labelsUrl: json['labels_url'],
    );
  }
}
