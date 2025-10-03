// screens/camera_screen.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import '../services/storage_service.dart';
import '../widgets/error_modal.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  bool _isDetecting = false;
  String? _recognitionResult;
  List<String>? _labels;

  final StorageService _storageService = StorageService();
  Timer? _detectionTimer;
  String? _trackedLabel;
  bool _isClosing = false; // Flag to prevent processing during screen closing

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadTfLiteModel();
  }

  Future<void> _loadTfLiteModel() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final modelPath = '${dir.path}/model.tflite';
      final labelsPath = '${dir.path}/labels.txt';
      final modelFile = File(modelPath);
      final labelsFile = File(labelsPath);
      final String labelsData;

      if (await modelFile.exists()) {
        _interpreter = Interpreter.fromFile(modelFile);
      } else {
        throw Exception("Nessun modello presente");
      }

      if (await labelsFile.exists()) {
        labelsData = await labelsFile.readAsString();
      } else {
        throw Exception("Nessuna lista etichette presente");
      }

      _labels = labelsData.split('\n');
      
    } catch (e) {
      showErrorModal(context, "Download Failed", e.toString());
    }
  }

  void _initializeCamera() {
    if (cameras.isEmpty) {
      // No camera available
      return;
    }
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _cameraController!.startImageStream((CameraImage cameraImage) {
        if (!_isDetecting && _interpreter != null && !_isClosing) {
          _isDetecting = true;
          _runModelOnFrame(cameraImage);
        }
      });
    });
  }

  void _onImageConfirmed(int imageId) async {
    if (_isClosing) return; // Prevent multiple calls
    _isClosing = true;

    print("Image confirmed with ID: $imageId. Saving and closing screen.");
    
    // Stop the camera stream BEFORE closing the screen to prevent the crash
    await _cameraController?.stopImageStream();
    
    _storageService.setIdImage(imageId);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _cancelDetectionTimer() {
    _detectionTimer?.cancel();
    _detectionTimer = null;
  }

  Future<void> _runModelOnFrame(CameraImage cameraImage) async {
    // FIX: Add a check at the very beginning of the function to ensure the screen isn't closing.
    if (_isClosing || _interpreter == null) {
      _isDetecting = false;
      return;
    }

    try {
      var inputTensor = _interpreter!.getInputTensor(0);
      var inputShape = inputTensor.shape;
      var outputTensor = _interpreter!.getOutputTensor(0);
      var outputShape = outputTensor.shape;
      
      var image = _convertCameraImage(cameraImage);
      if (image == null) {
         _isDetecting = false;
         return;
      }

      var resizedImage = img.copyResize(image, width: inputShape[1], height: inputShape[2]);
      
      var imageBytes = resizedImage.toUint8List();
      var input = imageBytes.reshape(inputShape);

      var output = List.filled(outputTensor.numElements(), 0).reshape(outputShape);

      _interpreter!.run(input, output);

      List<num> results = output[0];
      int topResultIndex = 0;
      num topResultScore = 0.0;
      for (int i = 0; i < results.length; i++) {
        if (results[i] > topResultScore) {
          topResultScore = results[i];
          topResultIndex = i;
        }
      }

      double confidence = topResultScore is int ? topResultScore / 255.0 : topResultScore.toDouble();
      String currentLabel = _labels != null && topResultIndex < _labels!.length ? _labels![topResultIndex] : '';

      if (confidence >= 0.90) {
        if (_trackedLabel != currentLabel) {
          _trackedLabel = currentLabel;
          _cancelDetectionTimer();
          _detectionTimer = Timer(const Duration(seconds: 3), () {
            _onImageConfirmed(topResultIndex);
          });
        }
      } else {
        _trackedLabel = null;
        _cancelDetectionTimer();
      }

      if(mounted) {
        setState(() {
          _recognitionResult = "$currentLabel (${(confidence * 100).toStringAsFixed(0)}%)";
        });
      }

    } catch (e) {
      print("Error running model on frame: $e");
    } finally {
      Future.delayed(const Duration(milliseconds: 200), () {
        _isDetecting = false;
      });
    }
  }
  
  img.Image? _convertCameraImage(CameraImage image) {
    try {
      if (image.format.group == ImageFormatGroup.yuv420) {
        final int width = image.width;
        final int height = image.height;
        final int uvRowStride = image.planes[1].bytesPerRow;
        final int uvPixelStride = image.planes[1].bytesPerPixel!;

        final yPlane = image.planes[0].bytes;
        final uPlane = image.planes[1].bytes;
        final vPlane = image.planes[2].bytes;

        final convertedImage = img.Image(width: width, height: height);
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
            final int index = y * width + x;

            final yp = yPlane[index];
            final up = uPlane[uvIndex];
            final vp = vPlane[uvIndex];
            
            int r = (yp + vp * 1.402).round().clamp(0, 255);
            int g = (yp - up * 0.344136 - vp * 0.714136).round().clamp(0, 255);
            int b = (yp + up * 1.772).round().clamp(0, 255);
            
            convertedImage.setPixelRgba(x, y, r, g, b, 255);
          }
        }
        return convertedImage;
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        return img.Image.fromBytes(
            width: image.width,
            height: image.height,
            bytes: image.planes[0].bytes.buffer,
            order: img.ChannelOrder.bgra,
        );
      }
    } catch (e) {
        print("Error converting image: $e");
    }
    return null;
  }


  @override
  void dispose() {
    // FIX: Set the closing flag as the very first step in dispose.
    _isClosing = true;
    _cancelDetectionTimer();
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.imageRecognition)),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _recognitionResult ?? AppLocalizations.of(context)!.pointAtObject,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
