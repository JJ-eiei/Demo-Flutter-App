class Target {
  final String title;
  final DateTime startDate;
  final int totalDays;
  final Set<String> doneDates; // เก็บเป็น 'YYYY-MM-DD'

  Target({
    required this.title,
    required this.startDate,
    this.totalDays = 21,
    Set<String>? doneDates,
  }) : doneDates = doneDates ?? <String>{};

  static String dKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool isDone(DateTime day) => doneDates.contains(dKey(day));

  void toggleDone(DateTime day) {
    final k = dKey(day);
    if (doneDates.contains(k)) {
      doneDates.remove(k);
    } else {
      doneDates.add(k);
    }
  }
}
