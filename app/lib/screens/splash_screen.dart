import 'package:flutter/material.dart';
import 'dart:async';
import 'location_screen.dart';
import '../services/storage_service.dart';
import 'main_hunt_screen.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 
import '../widgets/permission_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startAppFlow() async {
    // 1. Controlla se abbiamo già spiegato e richiesto i permessi.
    bool permissionsExplained = _storageService.getPermissionsExplained();
    if (!permissionsExplained) {
      // Se è la prima volta, mostra il dialogo di spiegazione.
      await showPermissionExplanationDialog(context);
      _storageService.setPermissionsExplained(true);
    }

    // 2. Richiedi i permessi necessari (fotocamera e posizione).
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
    ].request();

    // 3. Dopo aver gestito i permessi, controlla se c'è una partita in corso.
    int statusId = _storageService.getIdStatus();
    if (statusId != 0) {
      // Se una partita è in corso, vai direttamente alla schermata di gioco.
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainHuntScreen()),
        );
      }
    } else {
      // Altrimenti, pulisci i dati vecchi e vai alla selezione della caccia.
      await _storageService.clearAll();
       if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LocationScreen()),
        );
       }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              AppLocalizations.of(context)!.appName,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 48.0),
            ElevatedButton(
              onPressed: _startAppFlow,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.startAdventure,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
