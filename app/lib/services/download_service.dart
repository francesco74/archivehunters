// lib/services/download_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<String> _getFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  }

  Future<void> _downloadFile(String url, String savePath, Function(double) onProgress) async {
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(received / total);
        }
      },
    );
  }

  Future<void> downloadModel(String url, Function(double) onProgress) async {
    final path = await _getFilePath('model.tflite');
    await _downloadFile(url, path, onProgress);
  }

  Future<void> downloadLabels(String url, Function(double) onProgress) async {
    final path = await _getFilePath('labels.txt');
    await _downloadFile(url, path, onProgress);
  }

  Future<String> getModelPath() => _getFilePath('model.tflite');
  Future<String> getLabelsPath() => _getFilePath('labels.txt');

  Future<List<String>> loadLabels(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final content = await file.readAsString();
      return content.split('\n');
    }
    return [];
  }
}
