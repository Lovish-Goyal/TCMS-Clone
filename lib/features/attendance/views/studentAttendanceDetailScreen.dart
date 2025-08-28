import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../student/model/student_model.dart';
import '../models/attendance_model.dart';
import '../provider/providers.dart';

class StudentAttendanceDetailScreen extends ConsumerStatefulWidget {
  final Student student;

  const StudentAttendanceDetailScreen({super.key, required this.student});

  @override
  ConsumerState<StudentAttendanceDetailScreen> createState() =>
      _StudentAttendanceDetailScreenState();
}

class _StudentAttendanceDetailScreenState
    extends ConsumerState<StudentAttendanceDetailScreen> {
  AttendanceStatus? _selectedStatus = AttendanceStatus.present;
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _submitAttendance() async {
    final id = const Uuid().v4();

    final attendance = AttendanceModel(
      id: id,
      studentId: widget.student.studentId,
      status: _selectedStatus ?? AttendanceStatus.present,
      remarks: _remarksController.text.isEmpty ? null : _remarksController.text,
      timestamp: DateTime.now(),
    );

    await ref
        .read(attendanceProvider.notifier)
        .addOrUpdateAttendance(attendance);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance marked successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance - ${widget.student.studentName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<AttendanceStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: AttendanceStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatus = val;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _remarksController,
              decoration: const InputDecoration(
                labelText: 'Remarks (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitAttendance,
              child: const Text('Submit Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
