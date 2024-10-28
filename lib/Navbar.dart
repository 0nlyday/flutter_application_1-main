import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/Scan.dart';
import 'package:flutter_application_1/firstaid.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Navbar extends StatefulWidget {
  final String username;
  final String userId;

  const Navbar({Key? key, required this.username, required this.userId}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      Homepage(username: widget.username, userId: widget.userId),
      ScanPage(),
      FirstaidPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 169, 220, 251),
        color: const Color.fromARGB(255, 133, 198, 255),
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.center_focus_strong, color: Colors.white),
          Icon(Icons.local_hospital, color: Colors.white),
        ],
      ),
    );
  }
}