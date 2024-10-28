import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  File? _sideImage, _topImage, _bottomImage;
  int _imageCounter = 0;
  List<String>? _labels;
  List<Map<String, dynamic>> _topPredictions = [];
  late tfl.Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadModel();
    _loadLabels();
    _resetImages();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
    ].request();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/model_unquant.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> _loadLabels() async {
    final labelText = await rootBundle.loadString('assets/labels.txt');
    setState(() {
      _labels = labelText.split('\n');
    });
  }

  Future<void> _pickImage({ImageSource source = ImageSource.camera}) async {
  final pickedFile = await _picker.pickImage(source: source);

  if (pickedFile != null) {
    setState(() {
      if (_imageCounter == 0) {
        _sideImage = File(pickedFile.path);
      } else if (_imageCounter == 1) {
        _topImage = File(pickedFile.path);
      } else if (_imageCounter == 2) {
        _bottomImage = File(pickedFile.path);
      }
      _imageCounter++;
    });

    try {
      // บันทึกรูปเข้าแกลลอรี่
      final result = await GallerySaver.saveImage(pickedFile.path);
      if (result != null && result) {
        print('Image saved to gallery');
      } else {
        print('Failed to save image to gallery');
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }
}

  Future<void> _processImages() async {
    if (_sideImage != null && _topImage != null && _bottomImage != null) {
      final sideResult = await _runModelOnImage(_sideImage!);
      final topResult = await _runModelOnImage(_topImage!);
      final bottomResult = await _runModelOnImage(_bottomImage!);

      print('Side Image Results: $sideResult');
      print('Top Image Results: $topResult');
      print('Bottom Image Results: $bottomResult');

      Map<String, double> combinedResults = {};

      [sideResult, topResult, bottomResult].forEach((result) {
        if (result != null) {
          result.forEach((prediction) {
            String label = prediction['label'];
            double confidence = prediction['confidence'];
            combinedResults[label] = (combinedResults[label] ?? 0) + confidence;
          });
        }
      });

      List<Map<String, dynamic>> sortedResults = combinedResults.entries.map((entry) {
        return {
          'label': entry.key,
          'confidence': entry.value / 3
        };
      }).toList();
      sortedResults.sort((a, b) => b['confidence'].compareTo(a['confidence']));

      print('Predictions:');
      for (var prediction in sortedResults.take(3)) {
        print('Label: ${prediction['label']}, Confidence: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%');
      }

      setState(() {
        _topPredictions = [sortedResults.first];
      });

      _showResultsDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('กรุณาถ่ายให้ครบ 3 ภาพ'),
      ));
    }
  }

  Future<List<Map<String, dynamic>>?> _runModelOnImage(File image) async {
    img.Image? imageTemp = img.decodeImage(image.readAsBytesSync());
    if (imageTemp == null) return null;
    
    img.Image resizedImage = img.copyResize(imageTemp, width: 224, height: 224);
    Float32List inputData = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        int pixel = resizedImage.getPixel(x, y);
        inputData[pixelIndex++] = img.getRed(pixel) / 255.0;
        inputData[pixelIndex++] = img.getGreen(pixel) / 255.0;
        inputData[pixelIndex++] = img.getBlue(pixel) / 255.0;
      }
    }

    var outputShape = _interpreter.getOutputTensor(0).shape;
    var output = List.filled(outputShape[1], 0).reshape([1, outputShape[1]]);

    _interpreter.run(inputData.reshape([1, 224, 224, 3]), output);

    List<Map<String, dynamic>> results = [];
    for (int i = 0; i < outputShape[1]; i++) {
      results.add({
        'confidence': output[0][i],
        'label': _labels![i],   
      });
    }

    results.sort((a, b) => b['confidence'].compareTo(a['confidence']));
    return results.take(3).toList(); // แสดงผลลัพธ์ 3 อันดับแรกตามค่า confidence
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
              Center(
                child: Text('ผลลัพธ์'),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._topPredictions.map((prediction) {
                return ListTile(
                  title: Text(prediction['label']),
                  trailing: Text('${(prediction['confidence'] * 100).toStringAsFixed(2)}%'),
                );
              }).toList(),
              SizedBox(height: 20),
              Text(
                'ต้องการกรอกคุณลักษณะเพิ่มเติมเพื่อผลลัพธ์ที่ดีขึ้นหรือไม่?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                 Navigator.of(context).pushNamed('/mushroomAttributesPage', arguments: {
                'mushroomName': _topPredictions.first['label'],
                'percentPredic': _topPredictions.first['confidence'] * 100,
              });
              },
            ),
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  // ignore: deprecated_member_use
  return WillPopScope(
    onWillPop: () async {
      _resetImages();
      return true;  // allows pop
    },
    child: Scaffold(
        appBar: AppBar(
          title: Text("Scan Page"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetImages,
            ),
          ],
        ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImagePreview('Side', _sideImage),
                  _buildImagePreview('Top', _topImage),
                  _buildImagePreview('Bottom', _bottomImage),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'กรุณาถ่ายให้ครบ 3 ภาพ แล้วกด ตกลง',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5 - 25,
            child: GestureDetector(
              onTap: _imageCounter < 3 ? () => _pickImage() : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 99, 183, 228),
                      Color.fromARGB(255, 106, 157, 234),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.camera_alt,
                  color: _imageCounter < 3 ? Colors.white : Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _processImages,
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  void _resetImages() {
    setState(() {
      _sideImage = null;
      _topImage = null;
      _bottomImage = null;
      _imageCounter = 0;
      _topPredictions.clear();
    });
  }

  Widget _buildImagePreview(String label, File? imageFile) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(8),
        height: 160,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: imageFile != null
            ? Image.file(imageFile, fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(label),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }
}