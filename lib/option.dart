import 'dart:convert';

import 'package:flutter/material.dart';

String jsonData = '''
  {
  "mushrooms": [
      {
        "name": "Macrolepiota procera (เห็ดกระโดง)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "มีเกล็ด",
        "cap_color": "ขาว white",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "มี"
      },
      {
        "name": "Macrolepiota procera (เห็ดกระโดง)",
        "cap": "หมวกแบน",
        "cap_texture": "มีเกล็ด",
        "cap_color": "ขาว white",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "มี"
      },
      {
        "name": "Schizophyllum commune (เห็ดตีนตุ๊กแก)",
        "cap": "ทรงพัด",
        "cap_texture": "มีเส้นใย",
        "cap_color": "ขาว white",
        "gill_color": "น้ำตาล",
        "stem": "ไม่มี",
        "ring": "ไม่มี"
      },
      {
        "name": "Schizophyllum commune (เห็ดตีนตุ๊กแก)",
        "cap": "ทรงพัด",
        "cap_texture": "มีเส้นใย",
        "cap_color": "น้ำตาล brown",
        "gill_color": "น้ำตาล",
        "stem": "ไม่มี",
        "ring": "ไม่มี"
      },
      {
        "name": "Gyromitra esculenta (เห็ดสมองวัว)",
        "cap": "ไม่ทราบ",
        "cap_texture": "ขรุขระ",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ไม่มี",
        "stem": "ป้อม",
        "ring": "ไม่มี"
      },
      {
        "name": "Gyromitra esculenta (เห็ดสมองวัว)",
        "cap": "รูปอานม้า saddle",
        "cap_texture": "ลอน wave",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ไม่มี",
        "stem": "ป้อม",
        "ring": "ไม่มี"
      },
      {
        "name": "Lepista nuda (เห็ดชงโค)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "เรียบ",
        "cap_color": "น้ำตาล brown",
        "gill_color": "น้ำตาล",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Lepista nuda (เห็ดชงโค)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "เรียบ",
        "cap_color": "ม่วง purple",
        "gill_color": "ม่วง purple",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Ganoderma applanatum (เห็ดหูช้าง)",
        "cap": "ทรงพัด",
        "cap_texture": "ขรุขระ",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ไม่มี",
        "stem": "ไม่มี",
        "ring": "ไม่มี"
      },
      {
        "name": "Ganoderma applanatum (เห็ดหูช้าง)",
        "cap": "ครึ่งวงกลม semicircle",
        "cap_texture": "ขรุขระ",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ไม่มี",
        "stem": "ไม่มี",
        "ring": "ไม่มี"
      },
      {
        "name": "Cantharellus cibarius (เห็ดมันปู)",
        "cap": "ทรงกรวย",
        "cap_texture": "เรียบ",
        "cap_color": "เหลือง yellow",
        "gill_color": "เหลือง",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Cantharellus cibarius (เห็ดมันปู)",
        "cap": "ปากแตร cuspidor",
        "cap_texture": "เรียบ",
        "cap_color": "เหลือง yellow",
        "gill_color": "เหลือง",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Coprinellus disseminatus (เห็ดหมวกคุ่ม)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "ร่อง",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Coprinellus disseminatus (เห็ดหมวกคุ่ม)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "ร่อง",
        "cap_color": "ขาว white",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Amanita pantherine (เห็ดเกล็ดดาว)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "มีเกล็ด",
        "cap_color": "แดง red",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "มี"
      },
      {
        "name": "Amanita pantherine (เห็ดเกล็ดดาว)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "มีเกล็ด",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "มี"
      },
      {
        "name": "Amanita hemibapha (เห็ดไข่ไก่)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "เรียบ",
        "cap_color": "ส้ม",
        "gill_color": "เหลือง",
        "stem": "ทรงกระบอก",
        "ring": "มี"
      },
      {
        "name": "Hygrocybe Cantharellus (เห็ดประทัดจีน)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "เรียบ",
        "cap_color": "แดง red",
        "gill_color": "เหลือง",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      },
      {
        "name": "Boletus edulis (เห็ดตับเต่ากระโหลก)",
        "cap": "หมวกคว่ำ",
        "cap_texture": "เรียบ",
        "cap_color": "น้ำตาล brown",
        "gill_color": "ขาว",
        "stem": "ทรงกระบอก",
        "ring": "ไม่มี"
      }
    ]
  }
''';

/*
                TODO: Create option
                  1. need to name mushroom and percent of value predic from page scan
                  2. add UI cap_color of page option then to add value in newAttributes
                  3. optional change logic incress and decress in forEach of variable matchingAttributes
                  4. show updatedPercent this page or new design
                 */
Map<String, dynamic> mushroomData = jsonDecode(jsonData);

class MushroomAttributesPage extends StatefulWidget {
  @override
  _MushroomAttributesPageState createState() => _MushroomAttributesPageState();
}

class _MushroomAttributesPageState extends State<MushroomAttributesPage> {
  String? selectedMushroomCap;
  String? selectedMushroomSurface;
  String? selectedMushroomCapColor;
  String? selectedMushroomGill;
  String? selectedMushroomStalk;
  String? selectedMushroomRing;
  String mushroomName = '';
  double percentPredic = 0.0;
  String updatedPercent = '';

  @override
  void initState() {
    super.initState();
    // รับค่า mushroomName และ percentPredic ที่ส่งมาจาก ScanPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      if (args != null) {
        setState(() {
          mushroomName = args['mushroomName'];
          percentPredic = args['percentPredic'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('กรุณากรอกคุณลักษณะเห็ดเพิ่มเติม'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('หมวกเห็ด'),
            _buildRadioButton('กลม', selectedMushroomCap, 'cap'),
            _buildRadioButton('หมวกแบน', selectedMushroomCap, 'cap'),
            _buildRadioButton('หมวกคว่ำ', selectedMushroomCap, 'cap'),
            _buildRadioButton('หมวกพัด', selectedMushroomCap, 'cap'),
            _buildRadioButton('หมวกกรวย', selectedMushroomCap, 'cap'),
            _buildRadioButton('รูปอานม้า', selectedMushroomCap, 'cap'),
            _buildRadioButton('ครึ่งวงกลม', selectedMushroomCap, 'cap'),
            _buildRadioButton('ปากแตร', selectedMushroomCap, 'cap'),
            const SizedBox(height: 15),

            _buildSectionTitle('ผิวของหมวกเห็ด'),
            _buildRadioButton('เรียบ', selectedMushroomSurface, 'cap_texture'),
            _buildRadioButton('ขรุขระ', selectedMushroomSurface, 'cap_texture'),
            _buildRadioButton('มีเกล็ด', selectedMushroomSurface, 'cap_texture'),
            _buildRadioButton('ร่อง', selectedMushroomSurface, 'cap_texture'),
            _buildRadioButton('เส้นใย', selectedMushroomSurface, 'cap_texture'),
            _buildRadioButton('ลอน', selectedMushroomSurface, 'cap_texture'),
            const SizedBox(height: 15),

            _buildSectionTitle('สีของหมวกเห็ด'),
            _buildRadioButton('สีขาว', selectedMushroomCapColor, 'cap_color'),
            _buildRadioButton('สีน้ำตาล', selectedMushroomCapColor, 'cap_color'),
            _buildRadioButton('สีดำ', selectedMushroomCapColor, 'cap_color'),
            _buildRadioButton('สีเทา', selectedMushroomCapColor, 'cap_color'),
            _buildRadioButton('สีเหลือง', selectedMushroomCapColor, 'cap_color'),
            _buildRadioButton('สีแดง', selectedMushroomCapColor, 'cap_color'),
            _buildRadioButton('สีม่วง', selectedMushroomCapColor, 'cap_color'),
            const SizedBox(height: 15),

            _buildSectionTitle('ครีบเห็ด'),
            _buildRadioButton('ไม่มี', selectedMushroomGill, 'gill_color'),
            _buildRadioButton('สีขาว', selectedMushroomGill, 'gill_color'),
            _buildRadioButton('สีน้ำตาล', selectedMushroomGill, 'gill_color'),
            _buildRadioButton('สีดำ', selectedMushroomGill, 'gill_color'),
            _buildRadioButton('สีเทา', selectedMushroomGill, 'gill_color'),
            _buildRadioButton('สีเหลือง', selectedMushroomGill, 'gill_color'),
            _buildRadioButton('สีม่วง', selectedMushroomGill, 'gill_color'),
            SizedBox(height: 15),

            _buildSectionTitle('ก้านเห็ด'),
            _buildRadioButton('ทรงกระบอก', selectedMushroomStalk, 'stem'),
            _buildRadioButton('ป้อม', selectedMushroomStalk, 'stem'),
            SizedBox(height: 15),

            _buildSectionTitle('วงแหวน'),
            _buildRadioButton('มี', selectedMushroomRing, 'ring'),
            _buildRadioButton('ไม่มี', selectedMushroomRing, 'ring'),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Map<String, String> newAttributes = {
                  "cap": selectedMushroomCap!,
                  "cap_texture": selectedMushroomSurface!,
                  "cap_color": selectedMushroomCapColor!,
                  "gill_color": selectedMushroomGill!,
                  "stem": selectedMushroomStalk!,
                  "ring": selectedMushroomRing!,
                };

                var mushroom = mushroomData['mushrooms'].firstWhere(
                  (m) => m['name'] == mushroomName,
                  orElse: () => null,
                );

                if (mushroom != null) {
                  int totalAttributes = newAttributes.length;
                  int matchingAttributes = 0;

                  newAttributes.forEach((key, value) {
                    if (mushroom[key] == value) {
                      matchingAttributes += 1;
                    }
                  });

                  double percentPerAttribute = (100 - percentPredic) / totalAttributes;
                  double calculatePercent = percentPredic + (matchingAttributes * percentPerAttribute);

                  print(totalAttributes);
                  print(matchingAttributes);


                  if (calculatePercent > 100) {
                    calculatePercent = 100;
                  }
                  print("Percent ${calculatePercent.toStringAsFixed(2)}%");

                  setState(() {
                    updatedPercent = calculatePercent.toStringAsFixed(2);
                  });

                  // Show result dialog
                  showResultDialog(context, updatedPercent);
                }
              },
              child: const Text(
                'ค้นหา',
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // โชว์ผลลัพธ์แบบ AlertDialog
  void showResultDialog(BuildContext context, String updatedPercent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "ผลลัพธ์",
            textAlign: TextAlign.center,
          ),
          content: Text("เปอร์เซ็นต์การคาดการณ์ใหม่: $updatedPercent%"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "ตกลง",
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildRadioButton(String title, String? groupValue, String group) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: groupValue,
      onChanged: (value) {
        setState(() {
          switch (group) {
            case 'cap':
              selectedMushroomCap = value;
              break;
            case 'cap_texture':
              selectedMushroomSurface = value;
              break;
            case 'cap_color':
              selectedMushroomCapColor = value;
              break;
            case 'gill_color':
              selectedMushroomGill = value;
              break;
            case 'stem':
              selectedMushroomStalk = value;
              break;
            case 'ring':
              selectedMushroomRing = value;
              break;
          }
        });
      },
    );
  }
}
