// screens/location_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/location.dart';
import '../services/storage_service.dart';
import '../services/geofence_service.dart';
import 'main_hunt_screen.dart';
import 'package:archive_hunters/l10n/app_localizations.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Future<List<Location>> _locations;
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final GeofenceService _geofenceService = GeofenceService();

  @override
  void initState() {
    super.initState();
    _locations = _apiService.getLocations();
  }

  void _retryFetchLocations() {
    setState(() {
      _locations = _apiService.getLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chooseHunt),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Location>>(
        future: _locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage =
                snapshot.error.toString().replaceFirst("Exception: ", "");
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.noHuntsAvailable,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: TextStyle(fontSize: 16, color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _retryFetchLocations,
                      child: Text(AppLocalizations.of(context)!.reload),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.noHuntsAvailable));
          } else {
            final locations = snapshot.data!;
            return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:
                        const Icon(Icons.location_on, color: Colors.orange),
                    title: Text(location.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(location.description),
                    onTap: () async {
                      int selectedId = int.tryParse(location.id) ?? 0;

                      await _storageService.clearAll();
                      await _storageService.setIdApp(selectedId);
                      await _storageService.setIdStatus(1);

                      // Salva le coordinate e l'URL del modello
                      await _storageService.setLatitude(location.latitude);
                      await _storageService.setLongitude(location.longitude);
                      await _storageService.setModelUrl(location.modelUrl);

                      // Avvia il servizio di geofencing con l'ID corretto
                      await _geofenceService.start(selectedId);

                      // Naviga alla schermata principale della caccia
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const MainHuntScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
