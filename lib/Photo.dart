import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MushroomCapturePage extends StatefulWidget {
  @override
  _MushroomCapturePageState createState() => _MushroomCapturePageState();
}

class _MushroomCapturePageState extends State<MushroomCapturePage> {
  final ImagePicker _picker = ImagePicker();
  File? _sideImage, _topImage, _bottomImage;
  int _imageCounter = 0; // Counter to track the image sequence

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
        _imageCounter++; // Increment the counter after each photo
      });
    }
  }

  void _processImages() {
    if (_sideImage != null && _topImage != null && _bottomImage != null) {
      // Process images to identify the mushroom
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please take all 3 photos'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Page"),
        automaticallyImplyLeading: false,
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
            ],
          ),
          Positioned(
            bottom: 20, // Adjust space from the bottom to place camera button
            left: MediaQuery.of(context).size.width * 0.5 - 25, // Center horizontally
            child: GestureDetector(
              onTap: _imageCounter < 3 ? () => _pickImage() : null, // Disable after 3 photos
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
                  color: _imageCounter < 3 ? Colors.white : Colors.grey, // Change color if disabled
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20, // Place the buttons at the bottom
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _processImages,
                  child: const Text(
                    'Done',
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
    );
  }

  Widget _buildImagePreview(String label, File? imageFile) {
    return GestureDetector(
      onTap: () {}, // Disable onTap to not allow retaking individual photos
      child: Container(
        margin: EdgeInsets.all(8),
        height: 150,  // Adjust height
        width: 100,   // Adjust width
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
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
}
