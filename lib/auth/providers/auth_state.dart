import '../../features/student/model/student_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> userData;

  AuthAuthenticated(this.userData);
}

class AuthRequiresRegistration extends AuthState {
  final String id;
  final String academyId;
  final String academyName;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String role;
  final DateTime? trialStartDate;
  final DateTime? trialEndDate;
  final bool isPremium;
  final String? photoUrl;

  AuthRequiresRegistration({
    required this.id,
    required this.academyId,
    required this.academyName,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.role,
    this.trialStartDate,
    this.trialEndDate,
    this.isPremium = false,
    this.photoUrl,
  });
}

class AuthSuccess extends AuthState {
  final Student user;

  AuthSuccess({required this.user});
}

class AuthLoggedOut extends AuthState {}

class AuthRegisterUser extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class AuthUnauthenticated extends AuthState {
  final String message;
  AuthUnauthenticated(this.message);
}
