import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/pages/home.dart';
import 'package:project/screens/pages/schedule.dart'; // HabitCalendarPage
import 'package:project/stores/targetstores.dart'; // TargetStore.targets
import 'package:project/models/targetprogress.dart'; // class Target

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  /// เป้าหมายที่ใช้แสดงใน Progress tab ตอนนี้
  Target? _currentTarget;

  /// เลือกเป้าหมายที่จะใช้ใน Progress tab
  Target? _resolveCurrentTarget() {
    final list = TargetStore.targets;
    if (list.isEmpty) {
      _currentTarget = null;
      return null;
    }

    // ถ้ายังไม่เคยเลือก หรือเป้าหมายเดิมโดนลบไปแล้ว
    if (_currentTarget == null || !list.contains(_currentTarget)) {
      _currentTarget = list.first; // หรือจะเปลี่ยนเป็น list.last ก็ได้
    }
    return _currentTarget;
  }

  List<Widget> get _pages => [
    const Home(),
    Builder(
      builder: (context) {
        final target = _resolveCurrentTarget();
        if (target == null) {
          return const Center(
            child: Text(
              'ยังไม่มีเป้าหมาย\nเพิ่มจากปุ่ม "เพิ่มเป้าหมาย" ก่อน',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return HabitCalendarPage(target: target);
      },
    ),
    const Center(child: Text('👤 โปรไฟล์', style: TextStyle(fontSize: 24))),
  ];

  final List<String> _titles = const ['Home', 'Progress', 'Profile'];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ถ้าอยากมี AppBar เหมือนก่อนหน้า ใส่กลับมาได้
      // appBar: AppBar(
      //   title: Text(_titles[_selectedIndex], style: const TextStyle(color: Colors.white)),
      //   centerTitle: true,
      //   backgroundColor: const Color.fromARGB(255, 255, 111, 0),
      // ),
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
