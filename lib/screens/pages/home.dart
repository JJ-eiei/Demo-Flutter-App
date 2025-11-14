import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/models/targetprogress.dart';
import 'package:project/screens/addtarget.dart';
import 'package:project/screens/pages/schedule.dart'; // 👈 ต้อง import HabitCalendarPage
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 81, 0, 255),
              const Color.fromARGB(255, 255, 99, 3).withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: targets.isEmpty
                  ? const Center(
                      child: Text(
                        'ยังไม่มีเป้าหมาย\nกดปุ่ม "เพิ่มเป้าหมาย" ด้านล่าง',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: targets.length,
                      itemBuilder: (context, index) {
                        final target = targets[index];
                        return _buildBox(
                          context,
                          target,
                        ); // 👈 ส่ง context ลงไป
                      },
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 255, 99, 3).withOpacity(0.9),
                    const Color.fromARGB(255, 255, 255, 255),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Addtarget(),
                          ),
                        );
                      },
                      child: const Text("เพิ่มเป้าหมาย"),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("ยืนยันการรีเซ็ต"),
                            content: const Text(
                              "ต้องการลบเป้าหมายทั้งหมดใช่หรือไม่?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("ยกเลิก"),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("ยืนยัน"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          setState(() {
                            TargetStore.clear();
                          });
                        }
                      },
                      child: const Text("รีเซ็ตทั้งหมด"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// กล่องเป้าหมาย 1 อัน
  /// - แตะ = ไปหน้า HabitCalendarPage ของเป้าหมายนั้น
  /// - ปัดจากขวา = แสดงปุ่มลบ (Slidable)
  Widget _buildBox(BuildContext context, Target target) {
    return Slidable(
      key: ValueKey(target.title),

      // Action ด้านขวา (ลบ)
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          // ⭐ ปุ่มแก้ไข
          CustomSlidableAction(
            onPressed: (_) async {
              final newName = await _renameTarget(context, target.title);
              if (newName != null && newName.trim().isNotEmpty) {
                setState(() {
                  final idx = TargetStore.targets.indexOf(target);
                  TargetStore.targets[idx] = Target(
                    title: newName,
                    startDate: target.startDate,
                    totalDays: target.totalDays,
                    doneDates: target.doneDates,
                  );
                });
              }
            },
            backgroundColor: Colors.transparent,
            child: SizedBox.expand(
              // ⭐ ทำให้ขยายเต็มพื้นที่
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(height: 5),
                    Text('แก้ไข', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),

          // ⭐ ปุ่มลบ
          CustomSlidableAction(
            onPressed: (_) {
              setState(() {
                TargetStore.targets.remove(target);
              });
            },
            backgroundColor: Colors.transparent,
            child: SizedBox.expand(
              // ⭐ ขยายเท่ากันกับปุ่มแก้ไข
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(height: 5),
                    Text('ลบ', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ตัวกล่องที่แตะได้
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // 👈 แตะแล้วไปหน้า HabitCalendarPage ของ target นี้เลย
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HabitCalendarPage(target: target),
            ),
          );
        },
        child: Container(
          height: 100,
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
              target.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> _renameTarget(BuildContext context, String oldName) async {
  final controller = TextEditingController(text: oldName);

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("แก้ไขชื่อเป้าหมาย"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "ชื่อใหม่",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("ยกเลิก"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
          child: const Text("บันทึก"),
        ),
      ],
    ),
  );
}
