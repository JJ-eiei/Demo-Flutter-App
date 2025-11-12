import 'package:project/models/targetprogress.dart';

class TargetStore {
  static final List<Target> targets = [];

  static void add(Target t) => targets.add(t);

  // helper หาเป้าหมายจากชื่อ (จริง ๆ ควรมี id)
  static Target? findByTitle(String title) {
    return targets.where((t) => t.title == title).cast<Target?>().firstOrNull;
  }
}
