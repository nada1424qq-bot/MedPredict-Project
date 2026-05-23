class MedicalHistoryModel {
  final String historyId;
  final String userId;
  final String predictionId;
  final String notes;
  final DateTime recordDate;
  final String status;
  final String doctorName;

  MedicalHistoryModel({
    required this.historyId,
    required this.userId,
    required this.predictionId,
    required this.notes,
    required this.recordDate,
    required this.status,
    required this.doctorName,
  });

  Map<String, dynamic> toMap() {
    return {
      'historyId': historyId,
      'userId': userId,
      'predictionId': predictionId,
      'notes': notes,
      'recordDate': recordDate.toIso8601String(),
      'status': status,
      'doctorName': doctorName,
    };
  }

  factory MedicalHistoryModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return MedicalHistoryModel(
      historyId: documentId,
      userId: map['userId'] as String? ?? '',
      predictionId: map['predictionId'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      recordDate: map['recordDate'] != null
          ? DateTime.parse(map['recordDate'] as String)
          : DateTime.now(),
      status: map['status'] as String? ?? '',
      doctorName: map['doctorName'] as String? ?? '',
    );
  }

  MedicalHistoryModel copyWith({
    String? historyId,
    String? userId,
    String? predictionId,
    String? notes,
    DateTime? recordDate,
    String? status,
    String? doctorName,
  }) {
    return MedicalHistoryModel(
      historyId: historyId ?? this.historyId,
      userId: userId ?? this.userId,
      predictionId: predictionId ?? this.predictionId,
      notes: notes ?? this.notes,
      recordDate: recordDate ?? this.recordDate,
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
    );
  }
}
