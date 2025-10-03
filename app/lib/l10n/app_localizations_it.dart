// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Archive Hunters';

  @override
  String get startAdventure => 'Inizia l\'avventura';

  @override
  String get chooseHunt => 'Scegli una Caccia al Tesoro';

  @override
  String get noHuntsAvailable => 'Nessuna caccia al tesoro disponibile.';

  @override
  String get map => 'Mappa';

  @override
  String get camera => 'Fotocamera';

  @override
  String get answer => 'Risposta';

  @override
  String get docs => 'Documenti';

  @override
  String get menu => 'Menu';

  @override
  String get submitAnswer => 'Invia la tua Risposta';

  @override
  String get yourAnswer => 'La tua risposta';

  @override
  String get submit => 'Invia';

  @override
  String get close => 'Chiudi';

  @override
  String get correctAnswer => 'Risposta corretta! Procedi al prossimo indizio.';

  @override
  String get wrongAnswer => 'Risposta sbagliata, riprova.';

  @override
  String get information => 'Informazioni';

  @override
  String get about => 'Info su';

  @override
  String get restart => 'Ricomincia';

  @override
  String get treasureMap => 'Mappa del Tesoro';

  @override
  String get imageRecognition => 'Riconoscimento Immagine';

  @override
  String get pointAtObject => 'Inquadra un oggetto';

  @override
  String get collectedDocuments => 'Documenti Raccolti';

  @override
  String get noDocumentsCollected => 'Nessun documento ancora raccolto.';

  @override
  String get reload => 'Ricarica';

  @override
  String get failedToLoadHunts =>
      'Errore nel caricare la lista delle cacce al tesoro:';

  @override
  String get failedToLoadHint =>
      'Impossibile caricare l\'indizio. Per favore, riprova.';

  @override
  String get failedToLoadDocuments =>
      'Impossibile caricare i documenti. Per favore riprova';

  @override
  String get downloadingHuntData => 'Scaricamento dati in corso';

  @override
  String get error => 'Errore';

  @override
  String get view => 'Visualizza';

  @override
  String get instructions => 'Istruzioni';

  @override
  String get checkAnswer => 'Controlla la risposta';

  @override
  String get ok => 'Ok';

  @override
  String get modelLoaded => 'Modello caricato correttamente';

  @override
  String get downloadingModel => 'Scaricamento modello...';

  @override
  String get updateModel => 'Aggiorna modello';

  @override
  String get aboutInfo =>
      'ArchiveHunters (V.1.0) è stato realizzato per BiblioLucca da Bertozzi Francesco.\nPer informazioni archivi@provincia.lucca.it';

  @override
  String get changeLanguage => 'Cambia linguaggio';

  @override
  String get failedDownload => 'Download fallito';

  @override
  String get english => 'Inglese';

  @override
  String get italian => 'Italiano';

  @override
  String get permissionsRequiredTitle => 'Permessi Necessari';

  @override
  String get permissionsRequiredBody =>
      'Per offrire la migliore esperienza, Archive Hunters ha bisogno di accedere alla tua posizione per guidarti nella caccia al tesoro e alla tua fotocamera per riconoscere gli indizi.\nI tuoi dati vengono utilizzati solo per le funzionalità del gioco.\n\nIn particolare\n• Posizione: Per guidarti sulla mappa e rilevare quando entri in una nuova area della caccia.\n• Fotocamera: Per riconoscere indizi e immagini che sono parte della caccia.';

  @override
  String get locationPermissionReason =>
      '• Posizione: Per guidarti sulla mappa e rilevare quando entri in una nuova area della caccia.';

  @override
  String get cameraPermissionReason =>
      '• Fotocamera: Per riconoscere indizi e immagini che sono parte della caccia.';

  @override
  String get okUnderstand => 'OK, ho capito';

  @override
  String get permissionsRequiredCamera =>
      'I permessi per l\'utilizzo della camera sono necessari per il riconoscimento delle immagini.';
}
