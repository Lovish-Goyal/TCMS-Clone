import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sems/auth/providers/auth_notifier.dart';
import '../../features/student/db/student_db.dart';
import 'auth_state.dart';
import 'student_auth.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    auth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn.instance,
    firestore: FirebaseFirestore.instance,
  );
});

final studentAuthProvider =
    StateNotifierProvider<StudentAuthNotifier, AuthState>((ref) {
      final studentDb = StudentDb.dbInstance;
      return StudentAuthNotifier(studentDb);
    });
