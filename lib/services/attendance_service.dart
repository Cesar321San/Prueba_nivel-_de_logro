import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/attendance_model.dart';
import '../models/user_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check in (register entry)
  Future<AttendanceModel> checkIn(UserModel user) async {
    try {
      final now = DateTime.now();
      final dateOnly = DateTime(now.year, now.month, now.day);

      // Check if already checked in today
      final existingAttendance = await getTodayAttendance(user.id);
      if (existingAttendance != null && existingAttendance.checkIn != null) {
        throw 'Ya has registrado tu entrada hoy';
      }

      // Determine status (late if after 8:15 AM)
      final lateTime = DateTime(now.year, now.month, now.day, 8, 15);
      final status = now.isAfter(lateTime) ? 'late' : 'present';

      final attendance = AttendanceModel(
        id: '',
        userId: user.id,
        userName: user.name,
        employeeId: user.employeeId,
        date: dateOnly,
        checkIn: now,
        status: status,
      );

      final docRef = await _firestore
          .collection('attendances')
          .add(attendance.toMap());

      return attendance.copyWith(id: docRef.id);
    } catch (e) {
      print('Error checking in: $e');
      rethrow;
    }
  }

  // Check out (register exit)
  Future<AttendanceModel> checkOut(String userId) async {
    try {
      final now = DateTime.now();
      final attendance = await getTodayAttendance(userId);

      if (attendance == null) {
        throw 'No se encontró registro de entrada para hoy';
      }

      if (attendance.checkOut != null) {
        throw 'Ya has registrado tu salida hoy';
      }

      await _firestore
          .collection('attendances')
          .doc(attendance.id)
          .update({'checkOut': now.millisecondsSinceEpoch});

      return attendance.copyWith(checkOut: now);
    } catch (e) {
      print('Error checking out: $e');
      rethrow;
    }
  }

  // Get today's attendance for a user
  Future<AttendanceModel?> getTodayAttendance(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('attendances')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
          .where('date', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return AttendanceModel.fromMap(doc.data(), doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting today attendance: $e');
      return null;
    }
  }

  // Get all attendances for today
  Stream<List<AttendanceModel>> getTodayAttendances() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection('attendances')
        .where('date', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .where('date', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get attendances by date
  Stream<List<AttendanceModel>> getAttendancesByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection('attendances')
        .where('date', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .where('date', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get attendances by date range
  Stream<List<AttendanceModel>> getAttendancesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return _firestore
        .collection('attendances')
        .where('date', isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
        .where('date', isLessThanOrEqualTo: end.millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get user's attendance history
  Stream<List<AttendanceModel>> getUserAttendanceHistory(String userId) {
    return _firestore
        .collection('attendances')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get attendance statistics for today
  Future<Map<String, int>> getTodayStatistics() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('attendances')
          .where('date', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
          .where('date', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
          .get();

      int present = 0;
      int late = 0;
      int absent = 0;

      for (var doc in querySnapshot.docs) {
        final attendance = AttendanceModel.fromMap(doc.data(), doc.id);
        switch (attendance.status) {
          case 'present':
            present++;
            break;
          case 'late':
            late++;
            break;
          case 'absent':
            absent++;
            break;
        }
      }

      return {
        'present': present,
        'late': late,
        'absent': absent,
        'total': present + late + absent,
      };
    } catch (e) {
      print('Error getting statistics: $e');
      return {
        'present': 0,
        'late': 0,
        'absent': 0,
        'total': 0,
      };
    }
  }

  // Calculate attendance percentage for today
  Future<double> getTodayAttendancePercentage(int totalEmployees) async {
    try {
      final stats = await getTodayStatistics();
      final present = stats['present'] ?? 0;
      final late = stats['late'] ?? 0;
      
      if (totalEmployees == 0) return 0.0;
      
      return ((present + late) / totalEmployees) * 100;
    } catch (e) {
      print('Error calculating percentage: $e');
      return 0.0;
    }
  }

  // Delete attendance record
  Future<void> deleteAttendance(String attendanceId) async {
    try {
      await _firestore.collection('attendances').doc(attendanceId).delete();
    } catch (e) {
      print('Error deleting attendance: $e');
      rethrow;
    }
  }

  // Update attendance record
  Future<void> updateAttendance(
    String attendanceId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection('attendances')
          .doc(attendanceId)
          .update(data);
    } catch (e) {
      print('Error updating attendance: $e');
      rethrow;
    }
  }
}
