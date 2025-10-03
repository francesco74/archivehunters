// lib/services/download_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<void> downloadModel(String modelUrl, String labelsUrl, Function(double) onProgress) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final modelSavePath = '${dir.path}/model.tflite';
      final labelsSavePath = '${dir.path}/labels.txt';
      
      await _dio.download(
        labelsUrl,
        labelsSavePath,
      );

      await _dio.download(
        modelUrl,
        modelSavePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Calculate and report the download progress
            onProgress(received / total);
          }
        },
      );
      
    } catch (e) {
      throw Exception("Errore durante il caricamento del modello.");
    }
  }
}
