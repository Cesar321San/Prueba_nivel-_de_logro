class AttendanceModel {
  final String id;
  final String userId;
  final String userName;
  final String? employeeId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String status; // 'present', 'absent', 'late'
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    this.notes,
  });

  // Convert from Firestore document
  factory AttendanceModel.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      employeeId: map['employeeId'],
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : DateTime.now(),
      checkIn: map['checkIn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkIn'])
          : null,
      checkOut: map['checkOut'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkOut'])
          : null,
      status: map['status'] ?? 'absent',
      notes: map['notes'],
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'employeeId': employeeId,
      'date': date.millisecondsSinceEpoch,
      'checkIn': checkIn?.millisecondsSinceEpoch,
      'checkOut': checkOut?.millisecondsSinceEpoch,
      'status': status,
      'notes': notes,
    };
  }

  // Copy with method for updates
  AttendanceModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? employeeId,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    String? status,
    String? notes,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  // Helper method to check if user is late (after 8:15 AM)
  bool get isLate {
    if (checkIn == null) return false;
    final lateTime = DateTime(
      checkIn!.year,
      checkIn!.month,
      checkIn!.day,
      8,
      15,
    );
    return checkIn!.isAfter(lateTime);
  }

  // Helper method to get formatted check-in time
  String get checkInFormatted {
    if (checkIn == null) return '--:--';
    final hour = checkIn!.hour > 12 ? checkIn!.hour - 12 : checkIn!.hour;
    final minute = checkIn!.minute.toString().padLeft(2, '0');
    final period = checkIn!.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Helper method to get formatted check-out time
  String get checkOutFormatted {
    if (checkOut == null) return '--:--';
    final hour = checkOut!.hour > 12 ? checkOut!.hour - 12 : checkOut!.hour;
    final minute = checkOut!.minute.toString().padLeft(2, '0');
    final period = checkOut!.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
