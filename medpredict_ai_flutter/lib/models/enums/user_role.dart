enum UserRole {
  PATIENT,
  ADMIN;

  String get displayName {
    switch (this) {
      case UserRole.PATIENT:
        return "Patient";
      case UserRole.ADMIN:
        return "Admin";
    }
  }
}

