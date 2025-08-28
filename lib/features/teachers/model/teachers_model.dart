class TeacherModel {
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

  TeacherModel({
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
  });

  Map<String, dynamic> toMap() {
    return {
      'academyId': academyId,
      'academyName': academyName,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': role,
      'trialStartDate': trialStartDate,
      'trialEndDate': trialEndDate,
      'isPremium': isPremium,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map, String id) {
    return TeacherModel(
      id: id,
      academyId: map['academyId'] ?? '',
      academyName: map['academyName'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      role: map['role'] ?? 'teacher',
      trialStartDate: map['trialStartDate']?.toDate(),
      trialEndDate: map['trialEndDate']?.toDate(),
      isPremium: map['isPremium'] ?? false,
    );
  }
}
