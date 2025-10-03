// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';
import '../models/game_state.dart';
import '../models/geofence_area.dart';
import '../models/answer_response.dart';
import '../models/document.dart'; // Import the new Document model
import 'storage_service.dart';
import '../settings.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  Future<List<Location>> getLocations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getLocations'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'ok') {
          final List<dynamic> locationsJson = data['result'];
          return locationsJson.map((json) => Location.fromJson(json)).toList();
        } else {
          throw Exception(data['error']);
        }
      } else {
        throw Exception(
            'Could not connect to the server (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('A network error occurred: $e');
    }
  }

  Future<GameState> getState({
    required int idLocation,
    required int idStatus,
    required int idApp,
    required int idAnswer,
    required int idImage,
    required String lang,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getState'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_location': idLocation,
          'id_status': idStatus,
          'id_app': idApp,
          'id_answer': idAnswer,
          'id_image': idImage,
          'lang': lang,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          return GameState.fromJson(data['result']);
        } else {
          throw Exception(data['error']);
        }
      } else {
        throw Exception(
            'Could not connect to the server (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('A network error occurred: $e');
    }
  }

  Future<List<GeofenceArea>> getGeofenceList({required int idApp}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getGeofenceList'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_app': idApp}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> pointsJson = data['result'];
          return pointsJson.map((json) => GeofenceArea.fromJson(json)).toList();
        } else {
          throw Exception(data['error']);
        }
      } else {
        throw Exception(
            'Could not connect to the server (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('A network error occurred: $e');
    }
  }

  Future<AnswerResponse> getAnswerId({required String answer}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkAnswer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_app': _storageService.getIdApp(),
          'id_status': _storageService.getIdStatus(),
          'answer': answer,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          return AnswerResponse.fromJson(data['result']);
        } else {
          throw Exception(data['error']);
        }
      } else {
        throw Exception(
            'Could not connect to the server (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('A network error occurred: $e');
    }
  }

  Future<List<Document>> getDocumentList(
      {required int idApp, required int idStatus}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getDocuments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_app': idApp, // Assuming 'selected_api' maps to our 'id_app'
          'id_status': idStatus,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // The API uses "result" instead of "status" for this call
        if (data['status'] == 'ok') {
          final List<dynamic> documentsJson = data['result'];
          return documentsJson.map((json) => Document.fromJson(json)).toList();
        } else {
          throw Exception(data['error'] ?? 'Failed to load documents.');
        }
      } else {
        throw Exception(
            'Could not connect to the server (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('A network error occurred: $e');
    }
  }
}
