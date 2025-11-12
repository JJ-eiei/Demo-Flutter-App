import 'package:flutter/material.dart';
import 'package:project/stores/targetstores.dart';
import 'package:project/models/targetprogress.dart'; // ✅ import model Target
import 'package:project/screens/dashboard.dart';

class Addtarget extends StatefulWidget {
  const Addtarget({super.key});

  @override
  State<Addtarget> createState() => _AddtargetState();
}

class _AddtargetState extends State<Addtarget> {
  final TextEditingController _targetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  void _saveTarget() {
    if (_formKey.currentState!.validate()) {
      // ✅ สร้าง Target object ใหม่
      final newTarget = Target(
        title: _targetController.text.trim(),
        startDate: DateTime.now(),
        totalDays: 21,
      );

      // ✅ เพิ่มลงคลัง
      TargetStore.add(newTarget);

      // ✅ กลับไปหน้า Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 238, 219),
      appBar: AppBar(
        title: const Text('ป้อนสิ่งที่คุณต้องการทำ'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 111, 0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'อยากพัฒนาตัวเองในเรื่องอะไร',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _targetController,
                  decoration: const InputDecoration(
                    labelText: 'เป้าหมายของฉันคือ...',
                    border: OutlineInputBorder(),
                    hintText:
                        'เรียนรู้การลงทุน , เขียนโค้ดวันละ 1 ชั่วโมง , ...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกเป้าหมายก่อน';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTarget,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 111, 0),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('บันทึกเป้าหมาย'),
            ),
          ],
        ),
      ),
    );
  }
}
