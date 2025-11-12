import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/screens/addtarget.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for loading (e.g., fetching data)
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen or perform any action after the welcome screen
      // For example:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Addtarget()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 111, 0),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(252, 255, 255, 255),
              ),
            ),
            SizedBox(height: 20),
            SpinKitPulsingGrid(color: Colors.white, size: 50.0),
          ],
        ),
      ),
    );
  }
}
