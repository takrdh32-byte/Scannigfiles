import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';

/// Stores medicines as plain Maps in a Hive box — no codegen/build_runner
/// required, keeps CI builds simple and fast.
class StorageService {
  static const String boxName = 'medicines_box';
  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  static Box get _b {
    if (_box == null) {
      throw StateError('StorageService.init() must be called before use');
    }
    return _box!;
  }

  static List<Medicine> getAll() {
    return _b.values
        .map((e) => Medicine.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
  }

  static Future<void> save(Medicine m) async {
    await _b.put(m.id, m.toMap());
  }

  static Future<void> delete(String id) async {
    await _b.delete(id);
  }
}
