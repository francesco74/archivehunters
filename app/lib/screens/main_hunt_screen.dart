// screens/main_hunt_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/storage_service.dart';
import '../services/geofence_service.dart';
import '../models/geofence_area.dart';
import 'map_screen.dart';
import 'camera_screen.dart' if (dart.library.html) 'camera_screen_stub.dart';
import 'documents_screen.dart';
import '../widgets/answer_modal.dart';
import '../widgets/menu_modal.dart';
import 'package:archive_hunters/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/game_state_service.dart';

class MainHuntScreen extends StatefulWidget {
  const MainHuntScreen({super.key});

  @override
  _MainHuntScreenState createState() => _MainHuntScreenState();
}

class _MainHuntScreenState extends State<MainHuntScreen> {
  final StorageService _storageService = StorageService();
  final GeofenceService _geofenceService = GeofenceService();
  late StreamSubscription<int> _geofenceSubscription;

  List<GeofenceArea> _geofenceAreas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameStateService>(context, listen: false)
          .fetchAndUpdateState(context);
    });
    _listenToGeofenceEvents();
    _geofenceAreas = _geofenceService.loadedAreas;
  }

  @override
  void dispose() {
    _geofenceSubscription.cancel();
    super.dispose();
  }

  void _listenToGeofenceEvents() {
    _geofenceSubscription = _geofenceService.geofenceStream.listen((areaId) {
      print("Entered geofence area: $areaId");
      Provider.of<GameStateService>(context, listen: false)
          .updateLocation(areaId, context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have entered a new area! (ID: $areaId)'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Consumer<GameStateService>(
                        builder: (context, gameState, child) {
                          if (gameState.isLoading) {
                            return const CircularProgressIndicator(
                                color: Colors.white);
                          } else if (gameState.error != null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .failedToLoadHint,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red[300], fontSize: 18),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () =>
                                      gameState.fetchAndUpdateState(context),
                                  child: Text(
                                      AppLocalizations.of(context)!.reload),
                                ),
                              ],
                            );
                          } else {
                            int status = _storageService.getIdStatus();
                            int location = _storageService.getIdLocation();
                            String hint = gameState.hint;
                            return Text(
                              '$hint\nS:$status\nP:$location',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  height: 1.5),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 120,
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHuntButton(context, Icons.map, 'Map', () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MapScreen(
                          centerLat: _storageService.getLatitude(),
                          centerLng: _storageService.getLongitude(),
                          geofenceAreas:
                              _geofenceAreas, // Pass the geofence data
                        ),
                      ));
                    }),
                    _buildHuntButton(context, Icons.camera_alt,
                        AppLocalizations.of(context)!.camera, () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CameraScreen()));
                      Provider.of<GameStateService>(context, listen: false)
                          .fetchAndUpdateState(context);
                    }),
                    _buildHuntButton(
                        context,
                        Icons.lightbulb,
                        AppLocalizations.of(context)!.answer,
                        () => showAnswerModal(context)),
                    // New button for documents
                    _buildHuntButton(context, Icons.article,
                        AppLocalizations.of(context)!.docs, () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const DocumentsScreen()));
                    }),
                    _buildHuntButton(
                        context,
                        Icons.menu,
                        AppLocalizations.of(context)!.menu,
                        () => showMenuModal(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHuntButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
