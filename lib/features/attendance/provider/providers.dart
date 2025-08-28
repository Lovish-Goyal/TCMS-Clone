import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../db/attendance_db.dart';
import '../models/attendance_model.dart';

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
      (ref) => AttendanceNotifier(),
    );

class AttendanceNotifier extends StateNotifier<List<AttendanceModel>> {
  AttendanceNotifier() : super([]);

  final _firestore = FirebaseFirestore.instance;

  Future<void> loadAttendanceByDate(DateTime date) async {
    // Load from local DB first
    final local = await AttendanceDb.instance.getAttendanceByDate(date);
    state = local;

    // Optionally sync from Firebase (could be optimized)
    final dateStr = date.toIso8601String().substring(0, 10);

    final snapshot = await _firestore
        .collection('attendance')
        .where('date', isEqualTo: dateStr)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final firebaseAttendance = snapshot.docs.map((doc) {
        final data = doc.data();
        return AttendanceModel(
          id: data['id'],
          studentId: data['studentId'],
          status: AttendanceStatus.values.firstWhere(
            (e) => e.name == data['status'],
            orElse: () => AttendanceStatus.absent,
          ),
          remarks: data['remarks'],
          timestamp: DateTime.parse(data['timestamp']),
        );
      }).toList();

      // Update local DB with Firebase data
      for (var att in firebaseAttendance) {
        await AttendanceDb.instance.addAttendance(att);
      }

      state = firebaseAttendance;
    }
  }

  Future<void> addOrUpdateAttendance(AttendanceModel attendance) async {
    // Update locally
    await AttendanceDb.instance.addAttendance(attendance);

    // Update state
    final idx = state.indexWhere((a) => a.id == attendance.id);
    if (idx >= 0) {
      state[idx] = attendance;
    } else {
      state = [...state, attendance];
    }

    // Sync with Firebase
    await _firestore.collection('attendance').doc(attendance.id).set({
      'id': attendance.id,
      'studentId': attendance.studentId,
      'status': attendance.status.name,
      'remarks': attendance.remarks,
      'timestamp': attendance.timestamp.toIso8601String(),
      'date': attendance.timestamp.toIso8601String().substring(0, 10),
    });
  }
}
