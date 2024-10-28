import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'accountpage.dart';
import 'Scan.dart';
import 'option.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/', //routeเริ่มต้นเมื่อรันแอป
        routes: {
          '/': (context) => const Login(),
          '/login': (context) => const Login(),
          '/register': (context) => const Register(),
          '/mushroomAttributesPage': (context) => MushroomAttributesPage(),
          
        },
      );
  }
}
