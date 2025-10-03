import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 
import 'package:provider/provider.dart';
import 'services/game_state_service.dart';
import 'dart:ui';

// Chiave globale per accedere allo stato dell'app e cambiare la lingua
final GlobalKey<_TreasureHuntAppState> appKey = GlobalKey();

Future<void> main() async {
  // Assicura che i servizi dei plugin siano inizializzati
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza il servizio di storage
  await StorageService().init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameStateService(),
      child: TreasureHuntApp(key: appKey),
    ),
  );
}

class TreasureHuntApp extends StatefulWidget {
  const TreasureHuntApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TreasureHuntAppState createState() => _TreasureHuntAppState();
}

class _TreasureHuntAppState extends State<TreasureHuntApp> {
  Locale? _locale;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() {
    String languageCode = _storageService.getLanguageCode();
    // Se non c'è una lingua salvata, getLanguageCode ritorna quella del dispositivo.
    setState(() {
      _locale = Locale(languageCode);
    });
  }

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
      locale: _locale, // Usa la lingua salvata o quella di default
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Inglese
        Locale('it'), // Italiano
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
