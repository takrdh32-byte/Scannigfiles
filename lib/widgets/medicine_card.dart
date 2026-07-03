import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';
import '../locale.dart';   // ✅ FIXED: pehle '../l10n/app_strings.dart' tha, ab '../locale.dart'

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onDelete,
  });

  Color _statusColor() {
    switch (medicine.status) {
      case MedicineStatus.expired:
        return AppTheme.danger;
      case MedicineStatus.expiringSoon:
        return AppTheme.warning;
      case MedicineStatus.valid:
        return AppTheme.safe;
    }
  }

  String _statusLabel() {
    switch (medicine.status) {
      case MedicineStatus.expired:
        return S.of('expired');
      case MedicineStatus.expiringSoon:
        return S.of('expiring_soon');
      case MedicineStatus.valid:
        return S.of('valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = medicine.daysLeft;
    final dayLabel = days >= 0
        ? '$days ${S.of('days_left')}'
        : '${-days} ${S.of('days_ago')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: medicine.imagePath != null &&
                        File(medicine.imagePath!).existsSync()
                    ? Image.file(File(medicine.imagePath!),
                        width: 56, height: 56, fit: BoxFit.cover)
                    : Container(
                        width: 56,
                        height: 56,
                        color: AppTheme.lightGrey,
                        child: const Icon(Icons.medication_outlined,
                            color: AppTheme.black),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(medicine.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(medicine.expiryDate),
                      style: const TextStyle(color: AppTheme.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _statusColor().withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(),
                            style: TextStyle(
                                color: _statusColor(),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(dayLabel,
                            style: const TextStyle(
                                color: AppTheme.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.grey),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}