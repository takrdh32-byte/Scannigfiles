import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

class AddEditScreen extends StatefulWidget {
  final Medicine? existing;
  final String? prefillName;
  final DateTime? prefillDate;
  final String? imagePath;

  const AddEditScreen({
    super.key,
    this.existing,
    this.prefillName,
    this.prefillDate,
    this.imagePath,
  });

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _batchCtrl;
  late final TextEditingController _notesCtrl;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? widget.prefillName ?? '');
    _batchCtrl = TextEditingController(text: e?.batchNo ?? '');
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _expiryDate = e?.expiryDate ?? widget.prefillDate;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 20),
      helpText: S.of('select_expiry_date'),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of('date_not_found'))),
      );
      return;
    }
    final id = widget.existing?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();
    final medicine = Medicine(
      id: id,
      name: _nameCtrl.text.trim(),
      expiryDate: _expiryDate!,
      batchNo: _batchCtrl.text.trim().isEmpty ? null : _batchCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      imagePath: widget.imagePath ?? widget.existing?.imagePath,
      addedOn: widget.existing?.addedOn,
    );
    await StorageService.save(medicine);
    await NotificationService.scheduleForMedicine(medicine);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing != null ? S.of('edit') : S.of('confirm_details')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of('medicine_name'),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: _nameCtrl),
            const SizedBox(height: 20),
            Text(S.of('expiry_date'),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _expiryDate != null
                          ? DateFormat('dd MMM yyyy').format(_expiryDate!)
                          : S.of('select_expiry_date'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(S.of('batch_no'),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: _batchCtrl),
            const SizedBox(height: 20),
            Text(S.of('notes'), style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: _notesCtrl, maxLines: 2),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(S.of('cancel')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text(S.of('save')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
