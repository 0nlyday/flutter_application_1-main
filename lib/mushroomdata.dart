import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataMushroomPage extends StatefulWidget {
  final Map<String, dynamic> mushroomData;

  DataMushroomPage({required this.mushroomData});

  @override
  _DataMushroomPageState createState() => _DataMushroomPageState();
}

class _DataMushroomPageState extends State<DataMushroomPage> {
  late Future<Map<String, dynamic>> _futureContent;

  @override
  void initState() {
    super.initState();
    _futureContent = fetchNewsContent(widget.mushroomData['mush_id'].toString());
  }

  Future<Map<String, dynamic>> fetchNewsContent(String mushroomData) async {
    String uri = "http://192.168.217.28/signup/view_mushroom.php?mush_id=$mushroomData";

    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var jsonResponse = json.decode(response.body);

        print('Decoded JSON: $jsonResponse');

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('image') &&
            jsonResponse.containsKey('mush_name') &&
            jsonResponse.containsKey('sci_name') &&
            jsonResponse.containsKey('mush_detail')) {
          return {
            'image': jsonResponse['image'],
            'mush_name': jsonResponse['mush_name'],
            'sci_name': jsonResponse['sci_name'],
            'mush_detail': jsonResponse['mush_detail'],
          };
        } else {
          throw Exception('Unexpected JSON format or missing keys');
        }
      } else {
        throw Exception('Failed to load news content');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            String imageUrl = data['image'] ?? ''; // ใช้ ?? เพื่อป้องกัน ค่าว่าง
            print('Image URL: $imageUrl');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Image loading error: $error');
                        return Text('Error loading image');
                      },
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    'ชื่อ: ${data['mush_name']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'ชื่อวิทยาศาสตร์: ${data['sci_name']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'รายละเอียด: ${data['mush_detail']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}