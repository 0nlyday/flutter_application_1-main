import 'package:flutter/material.dart';
import 'package:flutter_application_1/Navbar.dart';
import 'package:ionicons/ionicons.dart';

class FirstaidPage extends StatelessWidget {
  const FirstaidPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "การปฐมพยาบาล",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Navbar(username: '', userId: '',),
              ),
            );
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("lib/assets/First1.png"),
          ],
        ),
      ),
    );
  }
}
