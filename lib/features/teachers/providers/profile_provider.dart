// Provider for Teacher Profile (you'll need to implement the actual Firebase logic)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sems/features/teachers/model/teachers_model.dart';

final teacherProfileProvider =
    StateNotifierProvider<TeacherProfileNotifier, AsyncValue<TeacherModel?>>((
      ref,
    ) {
      return TeacherProfileNotifier();
    });

class TeacherProfileNotifier extends StateNotifier<AsyncValue<TeacherModel?>> {
  TeacherProfileNotifier() : super(const AsyncValue.loading());

  Future<void> loadTeacherProfile(String userId) async {
    try {
      state = const AsyncValue.loading();
      // TODO: Replace with actual Firebase call
      final doc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userId)
          .get();
      if (doc.exists) {
        final profile = TeacherModel.fromMap(doc.data()!, doc.id);
        state = AsyncValue.data(profile);
      }

      // // Mock data for now
      // await Future.delayed(const Duration(seconds: 1));
      // final mockProfile = TeacherModel(
      //   id: 'mock_id',
      //   academyId: 'TC2024001',
      //   academyName: 'Excellence Academy',
      //   name: 'John Doe',
      //   email: 'john.doe@example.com',
      //   phoneNumber: '+91 9876543210',
      //   address: '123 Education Street, Knowledge City',
      //   role: 'teacher',
      //   trialStartDate: DateTime(2025, 8, 24),
      //   trialEndDate: DateTime(2025, 9, 3),
      //   isPremium: false,
      // );
      // state = AsyncValue.data(mockProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    // TODO: Implement logout logic
    await FirebaseAuth.instance.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> upgradeAccount() async {
    // TODO: Implement upgrade logic
  }
}
