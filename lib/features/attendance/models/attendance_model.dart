enum AttendanceStatus { present, absent, leave }

class AttendanceModel {
  final String id;
  final String studentId;
  final AttendanceStatus status;
  final String? remarks;
  final DateTime timestamp;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.status,
    this.remarks,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'status': status.name,
      'remarks': remarks,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      studentId: map['studentId'],
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      remarks: map['remarks'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
