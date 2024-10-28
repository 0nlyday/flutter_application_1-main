import 'package:flutter/material.dart';
import 'package:flutter_application_1/accountpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAccountScreen extends StatefulWidget {
  final String username;
  final String userId;  // เพิ่มพารามิเตอร์ userId

  const EditAccountScreen({
    Key? key, 
    required this.username, 
    required this.userId,
  }) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentusernameController = TextEditingController();
  final _newusernameController = TextEditingController();

  Future<void> _updateusername() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.217.28/signup/Editusername.php'),
        body: {
          'id': '1', 
          'new_username': _newusernameController.text,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('อัปเดตชื่อผู้ใช้สำเร็จ')),
          );
          Navigator.pop(context); // กลับไปหน้าก่อนหน้า
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตชื่อผู้ใช้')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเครือข่าย')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เปลี่ยนชื่อบัญชีผู้ใช้')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset("lib/assets/mushroom.png", width: 150, height: 90),
              const SizedBox(height: 20),
              TextFormField(
                controller: _currentusernameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: widget.username,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newusernameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อบัญชีใหม่',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 61, 167, 249),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _updateusername,
                child: const Text(
                  'เปลี่ยนชื่อบัญชีผู้ใช้',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}