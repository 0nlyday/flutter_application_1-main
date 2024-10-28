import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final String newsId;

  NewsDetailPage({required this.newsId});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late Future<Map<String, dynamic>> _futureContent;

  @override
  void initState() {
    super.initState();
    _futureContent = fetchNewsContent(widget.newsId);
  }

  Future<Map<String, dynamic>> fetchNewsContent(String newsId) async {
    String uri = "http://192.168.217.28/signup/view_newsdata.php?id=$newsId";

    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('subtopic') &&
            jsonResponse.containsKey('image') &&
            jsonResponse.containsKey('created_at')) {
          return {
            'image': jsonResponse['image'],
            'subtopic': jsonResponse['subtopic'],
            'created_at': jsonResponse['created_at'],
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

  Future<void> _shareToLine(String content) async {
  final String encodedContent = Uri.encodeComponent(content);
  final Uri lineUrl = Uri.parse('https://line.me/R/share?text=$encodedContent');

  if (await canLaunchUrl(lineUrl)) {
    await launchUrl(lineUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $lineUrl';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เนื้อหาข่าว'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              // ดึงข้อมูลเนื้อหาที่จะส่ง
              var contentToShare = await _futureContent;
              String content = 'ข้อมูลข่าว:${contentToShare['subtopic']} \nวันที่: ${contentToShare['created_at']}';
              _shareToLine(content); // แชร์ไปยัง LINE
            },
          )
        ],
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
            String imageUrl = data['image'] ?? '';

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
                        return Text('Error loading image');
                      },
                    ),
                  SizedBox(height: 16.0),
                  if (data.containsKey('created_at'))
                    Text(
                      'Date: ${data['created_at']}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  SizedBox(height: 16.0),
                  if (data.containsKey('subtopic'))
                    Text(
                      data['subtopic'],
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
