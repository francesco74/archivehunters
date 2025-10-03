// lib/services/game_state_service.dart
import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'api_service.dart';
import 'package:archive_hunters/l10n/app_localizations.dart';

class GameStateService with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String _hint = '';
  String? _error;

  bool get isLoading => _isLoading;
  String get hint => _hint;
  String? get error => _error;

  // Questo metodo viene chiamato per avviare un nuovo gioco o aggiornare lo stato.
  Future<void> fetchAndUpdateState(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Notifica alla UI di mostrare il caricamento

    try {
      final gameState = await _apiService.getState(
        idLocation: _storageService.getIdLocation(),
        idStatus: _storageService.getIdStatus(),
        idApp: _storageService.getIdApp(),
        idAnswer: _storageService.getIdAnswer(),
        idImage: _storageService.getIdImage(),
        lang: _storageService.getLanguageCode(),
      );

      // Aggiorna lo storage con il nuovo stato
      await _storageService.setIdStatus(gameState.newStatusId);
      _hint = gameState.hint;
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica alla UI che il caricamento è finito (con successo o errore)
    }
  }

  // Metodi per aggiornare i singoli valori e triggerare un nuovo fetch
  Future<void> updateAnswer(int newAnswerId, BuildContext context) async {
    await _storageService.setIdAnswer(newAnswerId);
    await fetchAndUpdateState(context);
  }

  Future<void> updateImage(int newImageId, BuildContext context) async {
    await _storageService.setIdImage(newImageId);
    await fetchAndUpdateState(context);
  }

  Future<void> updateLocation(int newLocationId, BuildContext context) async {
    await _storageService.setIdLocation(newLocationId);
    await fetchAndUpdateState(context);
  }

  Future<void> updateStatus(int newStatus, BuildContext context) async {
    await _storageService.setIdStatus(newStatus);
    await fetchAndUpdateState(context);
  }

  Future<void> updateLanguage(String lang, BuildContext context) async {
    await _storageService.setLanguageCode(lang);
    await fetchAndUpdateState(context);
  }
}
