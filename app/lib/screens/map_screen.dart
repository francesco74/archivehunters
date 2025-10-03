// screens/map_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../models/geofence_area.dart';
import 'package:archive_hunters/l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  final double centerLat;
  final double centerLng;
  final List<GeofenceArea> geofenceAreas;
  const MapScreen({
    Key? key,
    required this.centerLat,
    required this.centerLng,
    required this.geofenceAreas,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _initializeLocation() async {
    // Ottieni la posizione iniziale
    try {
      _currentLocation = await _location.getLocation();
      // Controlla se il widget è ancora montato prima di chiamare setState
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Errore nel recuperare la posizione iniziale: $e");
    }

    // Ascolta i cambiamenti di posizione
    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      // Controlla se il widget è ancora montato
      if (mounted) {
        setState(() {
          _currentLocation = currentLocation;
        });
      }
    });
  }

  void _centerOnUser() {
    if (_currentLocation != null) {
      _mapController.move(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        15.0,
      );
    }
  }

  void _zoomIn() {
    _mapController.move(
        _mapController.camera.center, _mapController.camera.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(
        _mapController.camera.center, _mapController.camera.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.treasureMap),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(widget.centerLat, widget.centerLng),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'it.lucca.provincia.archivehunters',
          ),
          CircleLayer(
            circles: widget.geofenceAreas.map((area) {
              return CircleMarker(
                point: LatLng(area.latitude, area.longitude),
                radius: area.radius,
                useRadiusInMeter: true,
                color: const Color.fromARGB(255, 243, 33, 51).withOpacity(0.3),
                borderColor: const Color.fromARGB(255, 243, 33, 138),
                borderStrokeWidth: 2,
              );
            }).toList(),
          ),
          // Using only the simple OpenStreetMap layer
          MarkerLayer(
            markers: [
              if (_currentLocation != null)
                Marker(
                  point: LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  width: 80,
                  height: 80,
                  child: Image.asset(
                      'assets/icons/user_pin.png'), // Your custom user icon
                ),
              Marker(
                point: LatLng(widget.centerLat, widget.centerLng),
                width: 80,
                height: 80,
                child: Image.asset(
                    'assets/icons/center_pin.png'), // Your custom treasure icon
              ),
            ],
          ),
        ],
      ),
      // Simplified to a single button for centering on the user
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn_zoom_in",
            onPressed: _zoomIn,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn_zoom_out",
            onPressed: _zoomOut,
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn_center",
            onPressed: _centerOnUser,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
