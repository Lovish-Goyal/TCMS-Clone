import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../student/views/active_students_list.dart';
import 'studentAttendanceDetailScreen.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentNotifierProvider);
    final studentList = studentState.students;

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: studentList.isEmpty
          ? const Center(child: Text('No students found.'))
          : ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                final student = studentList[index];
                return ListTile(
                  title: Text(student.studentName),
                  subtitle: Text('ID: ${student.studentId}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentAttendanceDetailScreen(student: student),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
