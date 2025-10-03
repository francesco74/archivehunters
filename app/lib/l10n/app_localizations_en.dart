// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Archive Hunters';

  @override
  String get startAdventure => 'Start adventure';

  @override
  String get chooseHunt => 'Choose a Treasure Hunt';

  @override
  String get noHuntsAvailable => 'No treasure hunts available.';

  @override
  String get map => 'Map';

  @override
  String get camera => 'Camera';

  @override
  String get answer => 'Answer';

  @override
  String get docs => 'Docs';

  @override
  String get menu => 'Menu';

  @override
  String get submitAnswer => 'Submit Your Answer';

  @override
  String get yourAnswer => 'Your Answer';

  @override
  String get submit => 'Submit';

  @override
  String get close => 'Close';

  @override
  String get correctAnswer => 'Correct Answer! Proceed to the next clue.';

  @override
  String get wrongAnswer => 'Wrong answer, please try again.';

  @override
  String get information => 'Information';

  @override
  String get about => 'About';

  @override
  String get restart => 'Restart';

  @override
  String get treasureMap => 'Treasure Map';

  @override
  String get imageRecognition => 'Image Recognition';

  @override
  String get pointAtObject => 'Point at an object';

  @override
  String get collectedDocuments => 'Collected Documents';

  @override
  String get noDocumentsCollected => 'No documents collected yet.';

  @override
  String get reload => 'Reload';

  @override
  String get failedToLoadHunts => 'Failed to load hunts:';

  @override
  String get failedToLoadHint => 'Could not load the hint. Please try again.';

  @override
  String get failedToLoadDocuments =>
      'Could not load documents. Please try again';

  @override
  String get downloadingHuntData => 'Downloading Hunt Data';

  @override
  String get error => 'Error';

  @override
  String get view => 'View';

  @override
  String get instructions => 'Instructions';

  @override
  String get checkAnswer => 'Check answer';

  @override
  String get ok => 'Ok';

  @override
  String get modelLoaded => 'Model loaded successfully';

  @override
  String get downloadingModel => 'Downloading model...';

  @override
  String get updateModel => 'Update model';

  @override
  String get aboutInfo =>
      'ArchiveHunters(V.1.0) was created for BiblioLucca by Francesco Bertozzi. For information, please contact archivi@provincia.lucca.it';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get failedDownload => 'Download failed';

  @override
  String get english => 'English';

  @override
  String get italian => 'Italian';

  @override
  String get permissionsRequiredTitle => 'Permissions Required';

  @override
  String get permissionsRequiredBody =>
      'To provide the best experience, Archive Hunters needs access to your location to guide you in the treasure hunt and to your camera to recognize clues.\nYour data is used only for the game\'s functionality.\n\nSpecifically:\n•Location: To guide you on the map and detect when you enter a new hunt area.\n•Camera: To recognize clues and images that are part of the hunt.';

  @override
  String get locationPermissionReason =>
      '• Location: To guide you on the map and detect when you enter a new hunt area.';

  @override
  String get cameraPermissionReason =>
      '• Camera: To recognize clues and images that are part of the hunt.';

  @override
  String get okUnderstand => 'OK, I Understand';

  @override
  String get permissionsRequiredCamera =>
      'Camera permission is required to recognize images.';
}
