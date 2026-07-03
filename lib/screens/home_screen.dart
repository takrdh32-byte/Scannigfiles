import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../widgets/medicine_card.dart';
import '../locale.dart';                 // ✅ Changed
import '../theme/app_theme.dart';
import 'scan_screen.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    LocaleController.instance.addListener(_onLocaleChange);
    _refresh();
  }

  @override
  void dispose() {
    LocaleController.instance.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  void _refresh() {
    setState(() => _medicines = StorageService.getAll());
  }

  Future<void> _delete(Medicine m) async {
    await StorageService.delete(m.id);
    await NotificationService.cancelForMedicine(m);
    _refresh();
  }

  Future<void> _openScan() async {
    final result = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const ScanScreen()));
    if (result == true) _refresh();
  }

  Future<void> _openAddManual() async {
    final result = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const AddEditScreen()));
    if (result == true) _refresh();
  }

  Future<void> _openEdit(Medicine m) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddEditScreen(existing: m)),
    );
    if (result == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final expiredCount =
        _medicines.where((m) => m.status == MedicineStatus.expired).length;
    final soonCount = _medicines
        .where((m) => m.status == MedicineStatus.expiringSoon)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of('app_name')),
        actions: [
          TextButton(
            onPressed: () => LocaleController.instance.toggle(),
            child: Text(
              LocaleController.instance.lang == AppLang.en ? 'हिं' : 'EN',
              style: const TextStyle(
                  color: AppTheme.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (expiredCount > 0 || soonCount > 0)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$expiredCount ${S.of('expired')}, $soonCount ${S.of('expiring_soon')}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _medicines.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        S.of('no_medicines'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.grey, fontSize: 15),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _medicines.length,
                    itemBuilder: (context, i) {
                      final m = _medicines[i];
                      return MedicineCard(
                        medicine: m,
                        onTap: () => _openEdit(m),
                        onDelete: () => _delete(m),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'scan',
            onPressed: _openScan,
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(S.of('scan_medicine')),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'manual',
            onPressed: _openAddManual,
            backgroundColor: AppTheme.white,
            foregroundColor: AppTheme.black,
            elevation: 1,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}