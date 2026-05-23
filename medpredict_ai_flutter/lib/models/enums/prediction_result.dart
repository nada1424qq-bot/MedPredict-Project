enum PredictionResult {
  NORMAL,
  PNEUMONIA;

  String get displayName {
    switch (this) {
      case PredictionResult.NORMAL:
        return "Normal";
      case PredictionResult.PNEUMONIA:
        return "Pneumonia";
    }
  }
}
