enum RiskLevel {
  MILD,
  MODERATE,
  SEVERE;

  String get displayName {
    switch (this) {
      case RiskLevel.MILD:
        return "Mild";
      case RiskLevel.MODERATE:
        return "Moderate";
      case RiskLevel.SEVERE:
        return "Severe";
    }
  }
}
