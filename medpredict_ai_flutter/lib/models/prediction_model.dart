import 'enums/risk_level.dart';
import 'enums/prediction_result.dart';

class PredictionModel {
  final String predictionId;
  final String imageId;
  final String userId;
  final PredictionResult result;
  final double confidenceScore;
  final RiskLevel riskLevel;
  final DateTime predictionDate;
  final String imagePath;
  final String imageUrl; // URL to the image on the server

  PredictionModel({
    required this.predictionId,
    required this.imageId,
    required this.userId,
    required this.result,
    required this.confidenceScore,
    required this.riskLevel,
    required this.predictionDate,
    required this.imagePath,
    this.imageUrl = '', // Default empty string for backward compatibility
  });

  Map<String, dynamic> toMap() {
    return {
      'predictionId': predictionId,
      'imageId': imageId,
      'userId': userId,
      'result': result.name,
      'confidenceScore': confidenceScore,
      'riskLevel': riskLevel.name,
      'predictionDate': predictionDate.toIso8601String(),
      'imagePath': imagePath,
      'imageUrl': imageUrl,
    };
  }

  factory PredictionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PredictionModel(
      predictionId: documentId,
      imageId: map['imageId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      result: PredictionResult.values.firstWhere(
        (e) => e.name == map['result'],
        orElse: () => PredictionResult.NORMAL,
      ),
      confidenceScore: (map['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == map['riskLevel'],
        orElse: () => RiskLevel.MILD,
      ),
      predictionDate: map['predictionDate'] != null
          ? DateTime.parse(map['predictionDate'] as String)
          : DateTime.now(),
      imagePath: map['imagePath'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  PredictionModel copyWith({
    String? predictionId,
    String? imageId,
    String? userId,
    PredictionResult? result,
    double? confidenceScore,
    RiskLevel? riskLevel,
    DateTime? predictionDate,
    String? imagePath,
    String? imageUrl,
  }) {
    return PredictionModel(
      predictionId: predictionId ?? this.predictionId,
      imageId: imageId ?? this.imageId,
      userId: userId ?? this.userId,
      result: result ?? this.result,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      riskLevel: riskLevel ?? this.riskLevel,
      predictionDate: predictionDate ?? this.predictionDate,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
