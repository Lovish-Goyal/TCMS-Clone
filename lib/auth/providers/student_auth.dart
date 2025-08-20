import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/student/db/student_db.dart';
import '../../shared/utils/logger.dart';
import 'auth_state.dart';

class StudentAuthNotifier extends StateNotifier<AuthState> {
  final StudentDb _studentDb;

  StudentAuthNotifier(this._studentDb) : super(AuthInitial());

  Future<void> loginStudent({
    required String academyId,
    required String studentId,
    required String dateOfBirth,
  }) async {
    try {
      state = AuthLoading();
      final student = await _studentDb.verifyStudentLogin(
        academyId: academyId,
        studentId: studentId,
        dateOfBirth: dateOfBirth,
      );

      if (student != null) {
        if (student.isActive) {
          logger.i("Student login successful: ${student.studentId}");
          state = AuthSuccess(user: student);
        } else {
          logger.w("Student account deactivated: ${student.studentId}");
          state = AuthError(message: 'Your account is deactivated');
        }
      } else {
        logger.w("Invalid student credentials");
        state = AuthError(message: 'Invalid credentials');
      }
    } catch (e) {
      logger.e('Error during student login', error: e);
      state = AuthError(message: e.toString());
    }
  }
}
