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
  void initState() {
    super.initState();
    // Initial fetch handled by notifier's constructor
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentNotifierProvider);

    return SafeArea(
      child: Scaffold(
        // appBar: MyCustomAppBar(
        //   title: 'Students',
        //   onSearch: (query) {
        //     ref.read(studentNotifierProvider.notifier).search(query);
        //   },
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.info, color: Colors.white),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.send, color: Colors.white),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.more_vert, color: Colors.white),
        //     ),
        //   ],
        // ),
        body: Column(
          children: [
            // BatchSelector(
            //   initialValue: selectedBatchName,
            //   onBatchSelected: (value) {
            //     setState(() => selectedBatchName = value!);
            //     ref.read(studentNotifierProvider.notifier).filterByBatch(value);
            //   },
            // ),
            Expanded(
              child: studentState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : studentState.error != null
                  ? Center(child: Text(studentState.error!))
                  : ListView.builder(
                      itemCount: studentState.students.length,
                      itemBuilder: (context, index) {
                        final student = studentState.students[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 2,
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
              MaterialPageRoute(builder: (context) => AddStudentPage()),
            );
          },
          child: const Icon(Icons.send, color: Colors.white),
        ),
      ),
    );
  }
}

// Define state
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

// Notifier
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

  void search(String name) async {
    state = state.copyWith(isLoading: true);
    final list = await studentDb.getStudents();
    final filtered = list.where((s) => s.studentName.contains(name)).toList();
    state = state.copyWith(students: filtered, isLoading: false);
  }

  void filterByBatch(String batch) async {
    state = state.copyWith(isLoading: true);
    final list = await studentDb.getStudents();
    final filtered = (batch == 'All')
        ? list
        : list.where((s) => s.batchName == batch).toList();
    state = state.copyWith(students: filtered, isLoading: false);
  }
}

// Provider
final studentNotifierProvider =
    StateNotifierProvider<StudentNotifier, StudentState>((ref) {
      return StudentNotifier(StudentDb.dbInstance);
    });
