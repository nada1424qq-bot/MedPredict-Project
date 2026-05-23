import 'enums/risk_level.dart';

class HealthTipModel {
  final String tipId;
  final String tipText;
  final String category;
  final RiskLevel riskLevel;
  final DateTime createdDate;

  HealthTipModel({
    required this.tipId,
    required this.tipText,
    required this.category,
    required this.riskLevel,
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipId': tipId,
      'tipText': tipText,
      'category': category,
      'riskLevel': riskLevel.name,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory HealthTipModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HealthTipModel(
      tipId: documentId,
      tipText: map['tipText'] as String? ?? '',
      category: map['category'] as String? ?? '',
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == map['riskLevel'],
        orElse: () => RiskLevel.MILD,
      ),
      createdDate: map['createdDate'] != null
          ? DateTime.parse(map['createdDate'] as String)
          : DateTime.now(),
    );
  }

  HealthTipModel copyWith({
    String? tipId,
    String? tipText,
    String? category,
    RiskLevel? riskLevel,
    DateTime? createdDate,
  }) {
    return HealthTipModel(
      tipId: tipId ?? this.tipId,
      tipText: tipText ?? this.tipText,
      category: category ?? this.category,
      riskLevel: riskLevel ?? this.riskLevel,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
