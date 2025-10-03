import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'services/geofence_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 
import 'package:provider/provider.dart'; // Importa provider
import 'services/game_state_service.dart';

List<CameraDescription> cameras = [];

// A global key to access the app's state and change the locale
final GlobalKey<_TreasureHuntAppState> appKey = GlobalKey();

Future<void> main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the storage service
  await StorageService().init();
  
  // Initialize the geofence service
  await GeofenceService().init();


  // Obtain a list of the available cameras on the device.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameStateService(),
      child: TreasureHuntApp(key: appKey),
    ),
  );
}

class TreasureHuntApp extends StatefulWidget {
  const TreasureHuntApp({Key? key}) : super(key: key);

  @override
  _TreasureHuntAppState createState() => _TreasureHuntAppState();
}

 class _TreasureHuntAppState extends State<TreasureHuntApp> {
  Locale? _locale;
  final StorageService _storageService = StorageService();

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _storageService.setLanguageCode(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive Hunters',
      locale: _locale, // Use the stored locale
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('it'), // Italian
      ],
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
