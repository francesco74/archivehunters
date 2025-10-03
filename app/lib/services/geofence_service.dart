// services/geofence_service.dart
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'storage_service.dart';
import 'api_service.dart'; // Import the API service
import '../models/geofence_area.dart'; // Import the new model

class GeofenceService {
  static final GeofenceService _instance = GeofenceService._internal();
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  // The list of areas is now loaded from the API
  List<GeofenceArea> _areas = [];
  List<GeofenceArea> get loadedAreas => _areas;

  StreamSubscription<Position>? _positionStream;
  final StreamController<int> _geofenceStreamController =
      StreamController<int>.broadcast();

  factory GeofenceService() {
    return _instance;
  }

  GeofenceService._internal();

  Future<void> init() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  Stream<int> get geofenceStream => _geofenceStreamController.stream;

  // The start method now loads the areas before listening for location updates
  Future<void> start(int idApp) async {
    _areas = await _apiService.getGeofenceList(idApp: idApp);

    if (_positionStream != null) {
      _positionStream!.cancel();
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      _checkGeofences(position);
    });
  }

  void _checkGeofences(Position position) {
    if (_areas.isEmpty) return;

    for (var area in _areas) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        area.latitude,
        area.longitude,
      );

      if (distance <= area.radius) {
        int lastKnownArea = _storageService.getIdLocation();
        if (lastKnownArea != area.id) {
          _storageService.setIdLocation(area.id);
          _geofenceStreamController.add(area.id);
        }
        return;
      }
    }
  }

  void stop() {
    _positionStream?.cancel();
  }
}
