import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Archive Hunters'**
  String get appName;

  /// No description provided for @startAdventure.
  ///
  /// In en, this message translates to:
  /// **'Start adventure'**
  String get startAdventure;

  /// No description provided for @chooseHunt.
  ///
  /// In en, this message translates to:
  /// **'Choose a Treasure Hunt'**
  String get chooseHunt;

  /// No description provided for @noHuntsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No treasure hunts available.'**
  String get noHuntsAvailable;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @docs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get docs;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @submitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Your Answer'**
  String get submitAnswer;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer! Proceed to the next clue.'**
  String get correctAnswer;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer, please try again.'**
  String get wrongAnswer;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @treasureMap.
  ///
  /// In en, this message translates to:
  /// **'Treasure Map'**
  String get treasureMap;

  /// No description provided for @imageRecognition.
  ///
  /// In en, this message translates to:
  /// **'Image Recognition'**
  String get imageRecognition;

  /// No description provided for @pointAtObject.
  ///
  /// In en, this message translates to:
  /// **'Point at an object'**
  String get pointAtObject;

  /// No description provided for @collectedDocuments.
  ///
  /// In en, this message translates to:
  /// **'Collected Documents'**
  String get collectedDocuments;

  /// No description provided for @noDocumentsCollected.
  ///
  /// In en, this message translates to:
  /// **'No documents collected yet.'**
  String get noDocumentsCollected;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @failedToLoadHunts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load hunts:'**
  String get failedToLoadHunts;

  /// No description provided for @failedToLoadHint.
  ///
  /// In en, this message translates to:
  /// **'Could not load the hint. Please try again.'**
  String get failedToLoadHint;

  /// No description provided for @failedToLoadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Could not load documents. Please try again'**
  String get failedToLoadDocuments;

  /// No description provided for @downloadingHuntData.
  ///
  /// In en, this message translates to:
  /// **'Downloading Hunt Data'**
  String get downloadingHuntData;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check answer'**
  String get checkAnswer;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @modelLoaded.
  ///
  /// In en, this message translates to:
  /// **'Model loaded successfully'**
  String get modelLoaded;

  /// No description provided for @downloadingModel.
  ///
  /// In en, this message translates to:
  /// **'Downloading model...'**
  String get downloadingModel;

  /// No description provided for @updateModel.
  ///
  /// In en, this message translates to:
  /// **'Update model'**
  String get updateModel;

  /// No description provided for @aboutInfo.
  ///
  /// In en, this message translates to:
  /// **'ArchiveHunters(V.1.0) was created for BiblioLucca by Francesco Bertozzi. For information, please contact archivi@provincia.lucca.it'**
  String get aboutInfo;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @failedDownload.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get failedDownload;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @permissionsRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions Required'**
  String get permissionsRequiredTitle;

  /// No description provided for @permissionsRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'To provide the best experience, Archive Hunters needs access to your location to guide you in the treasure hunt and to your camera to recognize clues. Your data is used only for the game\'s functionality.'**
  String get permissionsRequiredBody;

  /// No description provided for @locationPermissionReason.
  ///
  /// In en, this message translates to:
  /// **'• Location: To guide you on the map and detect when you enter a new hunt area.'**
  String get locationPermissionReason;

  /// No description provided for @cameraPermissionReason.
  ///
  /// In en, this message translates to:
  /// **'• Camera: To recognize clues and images that are part of the hunt.'**
  String get cameraPermissionReason;

  /// No description provided for @okUnderstand.
  ///
  /// In en, this message translates to:
  /// **'OK, I Understand'**
  String get okUnderstand;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
