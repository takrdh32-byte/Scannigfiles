class Medicine {
  final String id;
  final String name;
  final DateTime expiryDate;
  final String? batchNo;
  final String? notes;
  final String? imagePath;
  final DateTime addedOn;

  Medicine({
    required this.id,
    required this.name,
    required this.expiryDate,
    this.batchNo,
    this.notes,
    this.imagePath,
    DateTime? addedOn,
  }) : addedOn = addedOn ?? DateTime.now();

  int get daysLeft => expiryDate.difference(DateTime.now()).inDays;

  MedicineStatus get status {
    final d = daysLeft;
    if (d < 0) return MedicineStatus.expired;
    if (d <= 30) return MedicineStatus.expiringSoon;
    return MedicineStatus.valid;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'expiryDate': expiryDate.toIso8601String(),
        'batchNo': batchNo,
        'notes': notes,
        'imagePath': imagePath,
        'addedOn': addedOn.toIso8601String(),
      };

  factory Medicine.fromMap(Map<dynamic, dynamic> map) => Medicine(
        id: map['id'] as String,
        name: map['name'] as String,
        expiryDate: DateTime.parse(map['expiryDate'] as String),
        batchNo: map['batchNo'] as String?,
        notes: map['notes'] as String?,
        imagePath: map['imagePath'] as String?,
        addedOn: map['addedOn'] != null
            ? DateTime.parse(map['addedOn'] as String)
            : DateTime.now(),
      );

  Medicine copyWith({
    String? name,
    DateTime? expiryDate,
    String? batchNo,
    String? notes,
    String? imagePath,
  }) {
    return Medicine(
      id: id,
      name: name ?? this.name,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNo: batchNo ?? this.batchNo,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      addedOn: addedOn,
    );
  }
}

enum MedicineStatus { expired, expiringSoon, valid }
