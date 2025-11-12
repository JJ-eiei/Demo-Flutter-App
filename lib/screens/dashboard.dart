import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/pages/home.dart';
import 'package:project/screens/pages/schedule.dart'; // <- มี HabitCalendarPage(target: ...)
import 'package:project/stores/targetstores.dart'; // <- มี TargetStore.targets
import 'package:project/models/targetprogress.dart'; // <- นิยาม class Target

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const Home(),
    // แท็บกลาง: ถ้ายังไม่มีเป้าหมาย แสดงข้อความ, ถ้ามีเอาอันแรกมาโชว์
    Builder(
      builder: (context) {
        if (TargetStore.targets.isEmpty) {
          return const Center(
            child: Text(
              'ยังไม่มีเป้าหมาย\nเพิ่มจากปุ่ม "บันทึกเป้าหมาย" ก่อน',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        final Target t = TargetStore.targets.first;
        return HabitCalendarPage(target: t);
      },
    ),
    const Center(child: Text('👤 โปรไฟล์', style: TextStyle(fontSize: 24))),
  ];

  final List<String> _titles = const ['Home', 'Progress', 'Profile'];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 255, 111, 0),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.track_changes, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
