import '../../models/prediction_model.dart';
import '../../models/enums/prediction_result.dart';
import '../../models/enums/risk_level.dart';

class PredictionsData {
  static List<PredictionModel> predictions = [
    PredictionModel(
      predictionId: '1',
      imageId: '1',
      userId: '1',
      result: PredictionResult.NORMAL,
      confidenceScore: 0.92,
      riskLevel: RiskLevel.MILD,
      predictionDate: DateTime.parse("2025-01-25T09:30:00Z"),
      imagePath: "assets/images/sample_xrays/normal_xray_1.jpg",
    ),
    PredictionModel(
      predictionId: '2',
      imageId: '2',
      userId: '1',
      result: PredictionResult.PNEUMONIA,
      confidenceScore: 0.87,
      riskLevel: RiskLevel.MODERATE,
      predictionDate: DateTime.parse("2025-01-28T11:45:00Z"),
      imagePath: "assets/images/sample_xrays/pneumonia_xray_1.jpg",
    ),
    PredictionModel(
      predictionId: '3',
      imageId: '3',
      userId: '2',
      result: PredictionResult.PNEUMONIA,
      confidenceScore: 0.94,
      riskLevel: RiskLevel.SEVERE,
      predictionDate: DateTime.parse("2025-01-29T15:20:00Z"),
      imagePath: "assets/images/sample_xrays/pneumonia_xray_2.jpg",
    ),
  ];
}
