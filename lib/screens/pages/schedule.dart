import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:project/models/targetprogress.dart'; // <-- ปรับ path ให้ตรงโปรเจกต์คุณ

class HabitCalendarPage extends StatefulWidget {
  final Target target; // ✅ รับทั้งโมเดลเข้ามา (ทางเลือก A)

  const HabitCalendarPage({super.key, required this.target});

  @override
  State<HabitCalendarPage> createState() => _HabitCalendarPageState();
}

class _HabitCalendarPageState extends State<HabitCalendarPage> {
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = _onlyDate(DateTime.now());
    _firstDay = _onlyDate(widget.target.startDate);
    _lastDay = _onlyDate(
      widget.target.startDate.add(Duration(days: widget.target.totalDays - 1)),
    );
  }

  // ตัดเวลาให้เหลือแต่วันที่
  DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

  // แปลงวันเป็น key string 'YYYY-MM-DD'
  String _dKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  bool _inRange(DateTime day) {
    final d = _onlyDate(day);
    return !d.isBefore(_firstDay) && !d.isAfter(_lastDay);
  }

  bool _isDone(DateTime day) {
    return widget.target.doneDates.contains(_dKey(day));
  }

  void _toggleDone(DateTime day) {
    final k = _dKey(day);
    setState(() {
      if (widget.target.doneDates.contains(k)) {
        widget.target.doneDates.remove(k);
      } else {
        widget.target.doneDates.add(k);
      }
      // ทางเลือก A: in-memory เท่านั้น (ยังไม่ persist ลงดิสก์)
    });
  }

  double _progress() {
    final total = widget.target.totalDays;
    final done = widget.target.doneDates.length.clamp(0, total);
    return total == 0 ? 0 : done / total;
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color.fromARGB(255, 255, 111, 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orange,
        centerTitle: true,
        title: Text('ตาราง • ${widget.target.title}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // แถบความคืบหน้า
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ความคืบหน้า: ${(_progress() * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress(),
                      minHeight: 10,
                      color: orange,
                      backgroundColor: orange.withOpacity(0.15),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ช่วง: ${_firstDay.toLocal().toString().split(' ').first} → ${_lastDay.toLocal().toString().split(' ').first}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ปฏิทิน
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: TableCalendar(
                firstDay: DateTime.utc(2015, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                availableGestures: AvailableGestures.horizontalSwipe,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                selectedDayPredicate: (day) => false,

                // แตะวัน = toggle ทำแล้ว/ยัง (เฉพาะช่วง challenge)
                onDaySelected: (selectedDay, focusedDay) {
                  if (_inRange(selectedDay)) {
                    _toggleDone(selectedDay);
                  }
                  setState(() => _focusedDay = focusedDay);
                },

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final inRange = _inRange(day);
                    final done = _isDone(day);

                    return _DayCell(
                      day: day.day,
                      highlight: inRange,
                      done: done,
                      color: orange,
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final inRange = _inRange(day);
                    final done = _isDone(day);

                    return _DayCell(
                      day: day.day,
                      highlight: inRange,
                      done: done,
                      color: orange,
                      outlineAsToday: true,
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    // วันนอกเดือน — จางลง
                    return Opacity(
                      opacity: 0.35,
                      child: _DayCell(
                        day: day.day,
                        highlight: _inRange(day),
                        done: _isDone(day),
                        color: orange,
                      ),
                    );
                  },
                ),
                onPageChanged: (f) => _focusedDay = f,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ปุ่มทำ "วันนี้" ให้เสร็จเร็ว ๆ
          FilledButton.icon(
            onPressed: () => _toggleDone(DateTime.now()),
            icon: const Icon(Icons.check_circle),
            label: const Text('ทำวันนี้แล้ว! (กดเพื่อเช็ก/ยกเลิก)'),
            style: FilledButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

/// วาดช่องวันแบบสวย + มีสถานะ (อยู่ในช่วง/เช็กแล้ว/วันนี้)
class _DayCell extends StatelessWidget {
  final int day;
  final bool highlight; // อยู่ในช่วง challenge หรือไม่
  final bool done; // เช็กแล้วหรือยัง
  final bool outlineAsToday;
  final Color color;

  const _DayCell({
    required this.day,
    required this.highlight,
    required this.done,
    required this.color,
    this.outlineAsToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = highlight ? color.withOpacity(0.12) : null;
    final border = Border.all(
      color: outlineAsToday
          ? Colors.blue
          : (highlight ? color.withOpacity(0.5) : Colors.transparent),
      width: outlineAsToday ? 1.4 : (highlight ? 1 : 0),
    );

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: base,
        border: border,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
                color: highlight ? color : null,
              ),
            ),
          ),
          if (done)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.check_circle, size: 18, color: color),
              ),
            ),
        ],
      ),
    );
  }
}
