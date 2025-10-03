import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic Keys
  static const String _idAppKey = 'id_app';
  static const String _idStatusKey = 'id_status';
  static const String _idImageKey = 'id_image';
  static const String _idAnswerKey = 'id_answer';
  static const String _idLocationKey = 'id_location';
  static const String _latitude = 'latitude';
  static const String _longitude = 'longitude';
  static const String _modelUrl = 'model_url';
  static const String _labelsUrl = 'labels_url';
  static const String _languageCodeKey = 'language_code';
  static const String _permissionsExplainedKey = 'permissionsExplained';

  bool havePermissionsBeenExplained() =>
      _prefs.getBool(_permissionsExplainedKey) ?? false;
  Future<void> setPermissionsAsExplained() async =>
      await _prefs.setBool(_permissionsExplainedKey, true);

  // id_app
  Future<void> setIdApp(int id) async => await _prefs.setInt(_idAppKey, id);
  int getIdApp() => _prefs.getInt(_idAppKey) ?? 0;

  // id_status
  Future<void> setIdStatus(int id) async =>
      await _prefs.setInt(_idStatusKey, id);
  int getIdStatus() => _prefs.getInt(_idStatusKey) ?? 0;

  // id_image
  Future<void> setIdImage(int id) async => await _prefs.setInt(_idImageKey, id);
  int getIdImage() => _prefs.getInt(_idImageKey) ?? 0;

  // id_answer
  Future<void> setIdAnswer(int id) async =>
      await _prefs.setInt(_idAnswerKey, id);
  int getIdAnswer() => _prefs.getInt(_idAnswerKey) ?? 0;

  // id_location
  Future<void> setIdLocation(int id) async =>
      await _prefs.setInt(_idLocationKey, id);
  int getIdLocation() => _prefs.getInt(_idLocationKey) ?? 0;

  // latitude
  Future<void> setLatitude(double latitude) async =>
      await _prefs.setDouble(_latitude, latitude);
  double getLatitude() => _prefs.getDouble(_latitude) ?? 0;

  // longitude
  Future<void> setLongitude(double longitude) async =>
      await _prefs.setDouble(_longitude, longitude);
  double getLongitude() => _prefs.getDouble(_longitude) ?? 0;

  // model URL
  Future<void> setModelUrl(String modelUrl) async =>
      await _prefs.setString(_modelUrl, modelUrl);
  String getModelUrl() => _prefs.getString(_modelUrl) ?? "";

  // labels URL
  Future<void> setLabelsUrl(String labelsUrl) async =>
      await _prefs.setString(_labelsUrl, labelsUrl);
  String getLabelsUrl() => _prefs.getString(_labelsUrl) ?? "";

  Future<void> setLanguageCode(String code) async =>
      await _prefs.setString(_languageCodeKey, code);
  String getLanguageCode() {
    final savedLangCode = _prefs.getString(_languageCodeKey);
    if (savedLangCode != null && savedLangCode.isNotEmpty) {
      return savedLangCode;
    }
    // If no language is saved, return the device's default language
    return PlatformDispatcher.instance.locale.languageCode;
  }

  // Method to clear all data for a new game
  Future<void> clearAll() async {
    final lang = getLanguageCode();
    final permsExplained = getPermissionsExplained();
    
    await _prefs.clear();
    
    await setLanguageCode(lang);
    await setPermissionsExplained(permsExplained);
  }

  bool getPermissionsExplained() =>
      _prefs.getBool(_permissionsExplainedKey) ?? false;
  Future<void> setPermissionsExplained(bool value) =>
      _prefs.setBool(_permissionsExplainedKey, value);
}
