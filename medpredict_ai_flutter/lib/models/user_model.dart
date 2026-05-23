import 'enums/user_role.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final DateTime dateJoined;
  final UserRole role;
  final bool isEmailVerified;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dateJoined,
    required this.role,
    this.isEmailVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'dateJoined': dateJoined.toIso8601String(),
      'role': role
          .displayName, // Storing as string representation or could use index/name
      'isEmailVerified': isEmailVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      dateJoined: DateTime.parse(map['dateJoined'] as String),
      role: UserRole.values.firstWhere(
        (e) => e.displayName == map['role'],
        orElse: () => UserRole.PATIENT, // Default fallback
      ),
      isEmailVerified: map['isEmailVerified'] as bool? ?? false,
    );
  }

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phone,
    DateTime? dateJoined,
    UserRole? role,
    bool? isEmailVerified,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateJoined: dateJoined ?? this.dateJoined,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
