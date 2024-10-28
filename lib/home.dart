import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'edible.dart';
import 'Poisonous.dart';
import 'news.dart';
import 'accountpage.dart';

class Homepage extends StatefulWidget {
  final String username;
  final String userId;

  const Homepage({
    Key? key, 
    required this.username, 
    required this.userId,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  final List<String> images = [
    'lib/assets/1.png', // First image path
    'lib/assets/2.png' // Second image path
  ];
  final ImagePicker picker = ImagePicker();
  List<dynamic> news = [];
  bool isLoading = true;
  Dio dio = Dio();

  File? _image;
  List<dynamic>? _compareImage;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isRunning = true;
    getRecord();

    loadModel().then((val) {
      setState(() {
        isLoading = false;
        isRunning = false;
      });
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    await Tflite.close();
    await Tflite.loadModel(
      model: "assets/mushroom_model.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> pickerImage() async {
    if (isRunning) {
      print("Interpreter is busy, please wait.");
      return;
    }

    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      isLoading = true;
      _image = File(image.path);
    });
    await classificationImage(File(image.path));
  }

  Future<void> classificationImage(File image) async {
    setState(() {
      isRunning = true;
    });

    try {
      final compareImage = await Tflite.runModelOnImage(
        path: image.path,
      );

      setState(() {
        _compareImage = compareImage;
      });
    } catch (e) {
      print("Failed to run model: $e");
    } finally {
      setState(() {
        isRunning = false;
        isLoading = false;
      });
    }
  }

  Future<void> getRecord() async {
    String uri = "http://192.168.217.28/signup/main_topic.php";
    try {
      Response response = await dio.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          news = json.decode(response.data);
          isLoading = false;
        });
        print(news);
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(223, 200, 239, 255),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 200, 185, 241),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image != null ? Image.file(_image!) : Container(),
                    const SizedBox(height: 10),
                    _compareImage != null
                        ? Text(
                            _compareImage!.isNotEmpty
                                ? "${_compareImage![0]["label"]}"
                                : "No results found",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          )
                        : Container(),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Category Mushroom",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.person_3_sharp,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountScreen(
                                    username: widget.username,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 180,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: -20,
                            right: 0,
                            child: Container(
                              height: 180,
                              child: PageView.builder(
                                controller:
                                    PageController(viewportFraction: 0.8),
                                itemCount: images.length,
                                itemBuilder: (_, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (i == 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MushroomEdiblePage(),
                                          ),
                                        );
                                      } else if (i == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PoisonousPage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(images[i]),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      child: const Text(
                        "Collection of news mushrooms",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: news.length,
                        itemBuilder: (context, index) {
                          var newsItem = news[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                ListTile(
                                  title: Text(newsItem['main_topic']),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailPage(
                                            newsId: newsItem['id']),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewsDetailPage(
                                              newsId: newsItem['id']),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'อ่านต่อ',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 130, 177, 215),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: pickerImage,
          //   backgroundColor: Colors.red,
          //   child: Icon(Icons.image),
          // ),
        ),
      ),
    );
  }
}
