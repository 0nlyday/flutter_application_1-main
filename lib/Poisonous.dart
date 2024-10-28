import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/mushroomdata.dart';

class PoisonousPage extends StatefulWidget {
  const PoisonousPage({Key? key}) : super(key: key);

  @override
  State<PoisonousPage> createState() => _PoisonousPageState();
}

class _PoisonousPageState extends State<PoisonousPage> {
  List userdata = [];
  List<dynamic> filteredData = [];
  String searchText = '';
  bool isLoading = true;

  Future<void> getrecord() async {
    try {
      var response = await http.get(Uri.parse("http://192.168.217.28/signup/poisonous_list.php"));
      print('Raw response body: ${response.body}');
      
      if (response.statusCode == 200) {
        // ตรวจสอบว่าเป็น JSON หรือไม่
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          userdata = jsonResponse; // กำหนดค่า userdata ให้เป็น jsonResponse 
          filteredData = userdata; 
          isLoading = false; 
        });
        print(userdata);
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    getrecord();
  }

  void search(String query) {
    setState(() {
      filteredData = userdata.where((item) =>
          item["mush_name"].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เห็ดมีพิษ")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      search(value); // เรียกใช้ฟังก์ชันค้นหาทุกครั้งที่มีการกรอกข้อมูล
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      if (index >= filteredData.length) {
                        return Container();
                      }

                      var newsItem = filteredData[index];
                      print('News item: $newsItem');

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(newsItem['mush_name'] ?? 'No name'),
                          onTap: () {                           
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DataMushroomPage(
                                  mushroomData: newsItem,
                                ),
                              ),
                            );
                            }
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
