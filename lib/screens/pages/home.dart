import 'package:flutter/material.dart';
import 'package:project/stores/targetstores.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final targets = TargetStore.targets; // ✅ ดึงลิสต์เป้าหมายทั้งหมด

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 111, 0),
      ),

      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "เป้าหมายของคุณ     ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final target = targets[index];
                return _buildBox(target.title);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String title) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 219, 180),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 112, 68, 68).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
