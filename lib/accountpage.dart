import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/ChangePassword.dart';
import 'package:flutter_application_1/editusername.dart';
import 'package:flutter_application_1/widgets/setting_item.dart';

class AccountScreen extends StatefulWidget {
  final String username;
  final String userId; // ตรวจสอบว่าใช้ userId ที่นี่

  const AccountScreen({Key? key, required this.username, required this.userId})
      : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "บัญชีผู้ใช้",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset("lib/assets/user.png", width: 70, height: 70),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.username), // แสดง username ที่ได้รับมา
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "การตั้งค่า",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "เปลี่ยนชื่อบัญชีผู้ใช้",
                icon: Ionicons.create,
                bgColor: Colors.green.shade100,
                iconColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAccountScreen(
                          username: widget.username, userId: widget.userId),
                    ),
                  );
                },
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "เปลี่ยนรหัสผ่าน",
                icon: Ionicons.key,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangePasswordPage(userId: widget.userId),
                    ),
                  );
                },
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "ออกจากระบบ",
                icon: Ionicons.log_out,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () async {
                  // Show the confirmation dialog
                  bool? shouldLogOut = await showDialog<bool>(
                    context: context,
                    barrierDismissible:
                        false, // Prevents dismissing the dialog by tapping outside
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text(
                          "แน่ใจหรือไม่ว่าคุณต้องการออกจากระบบ?",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("ยกเลิก",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // User pressed cancel
                            },
                          ),
                          TextButton(
                            child: const Text("ตกลง",
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // User pressed confirm
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // If the user confirmed, navigate to the login page
                  if (shouldLogOut == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  }
                },
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
TODO: change username and password
1. เปลี่ยน Username และ Password ตามพารามิเตอร์ที่ login
*/