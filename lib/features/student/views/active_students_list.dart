import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sems/features/student/views/add_student_page.dart';

import '../db/student_db.dart';
import '../model/student_model.dart';
import '../utils/student_card.dart';

class ActiveStudentsList extends ConsumerStatefulWidget {
  const ActiveStudentsList({super.key});

  @override
  ConsumerState<ActiveStudentsList> createState() => _ActiveStudentsListState();
}

class _ActiveStudentsListState extends ConsumerState<ActiveStudentsList> {
  String selectedBatchName = 'All';

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentNotifierProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Students'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedBatchName,
                items: <String>['All', 'Batch A', 'Batch B']
                    .map(
                      (batch) => DropdownMenuItem<String>(
                        value: batch,
                        child: Text(batch),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedBatchName = value);
                    ref
                        .read(studentNotifierProvider.notifier)
                        .filterByBatch(value);
                  }
                },
              ),
            ),

            Expanded(
              child: studentState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : studentState.error != null
                  ? Center(child: Text(studentState.error!))
                  : studentState.students.isEmpty
                  ? const Center(child: Text('No students found.'))
                  : ListView.builder(
                      itemCount: studentState.students.length,
                      itemBuilder: (context, index) {
                        final student = studentState.students[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: StudentCard(student: student),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 57, 2, 129),
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStudentPage()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

// Student State
class StudentState {
  final List<Student> students;
  final bool isLoading;
  final String? error;

  StudentState({this.students = const [], this.isLoading = false, this.error});

  StudentState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? error,
  }) {
    return StudentState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Student Notifier
class StudentNotifier extends StateNotifier<StudentState> {
  final StudentDb studentDb;

  StudentNotifier(this.studentDb) : super(StudentState()) {
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final students = await studentDb.getStudents();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Could not fetch students',
        isLoading: false,
      );
    }
  }

  Future<void> search(String name) async {
    state = state.copyWith(isLoading: true);
    try {
      final allStudents = await studentDb.getStudents();
      final filtered = allStudents
          .where(
            (s) =>
                s.studentName.toLowerCase().contains(name.toLowerCase().trim()),
          )
          .toList();
      state = state.copyWith(students: filtered, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Search failed', isLoading: false);
    }
  }

  Future<void> filterByBatch(String batch) async {
    state = state.copyWith(isLoading: true);
    try {
      final allStudents = await studentDb.getStudents();
      final filtered = batch == 'All'
          ? allStudents
          : allStudents.where((s) => s.batchName == batch).toList();
      state = state.copyWith(students: filtered, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Filtering failed', isLoading: false);
    }
  }
}

// Provider
final studentNotifierProvider =
    StateNotifierProvider<StudentNotifier, StudentState>(
      (ref) => StudentNotifier(StudentDb.dbInstance),
    );
