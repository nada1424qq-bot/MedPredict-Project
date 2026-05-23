class AdminModel {
  final String adminId;
  final String email;

  AdminModel({required this.adminId, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'adminId': adminId,
      'email': email,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AdminModel(
      adminId: documentId,
      email: map['email'] as String? ?? '',
    );
  }

  AdminModel copyWith({
    String? adminId,
    String? email,
  }) {
    return AdminModel(
      adminId: adminId ?? this.adminId,
      email: email ?? this.email,
    );
  }
}
