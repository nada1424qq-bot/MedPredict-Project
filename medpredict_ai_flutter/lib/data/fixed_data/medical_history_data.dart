import 'package:medpredict_ai_flutter/models/medical_history_model.dart';

class MedicalHistoryData {
  static List<MedicalHistoryModel> history = [
    MedicalHistoryModel(
      historyId: '1',
      userId: '1',
      predictionId: '101',
      notes:
          "Routine checkup. X-ray shows clear lungs. No signs of infection or abnormalities.",
      recordDate: DateTime.now().subtract(const Duration(days: 30)),
      status: "Normal",
      doctorName: "Dr. Sarah Smith",
    ),
    MedicalHistoryModel(
      historyId: '2',
      userId: '1',
      predictionId: '102',
      notes:
          "Patient reported persistent cough. X-ray analysis detected early signs of Pneumonia in the lower left lobe. Antibiotics prescribed.",
      recordDate: DateTime.now().subtract(const Duration(days: 14)),
      status: "Pneumonia",
      doctorName: "Dr. Michael Chen",
    ),
    MedicalHistoryModel(
      historyId: '3',
      userId: '1',
      predictionId: '103',
      notes:
          "Follow-up scan. Infection has cleared significantly. Lungs appear mostly clear. Continue medication for 3 more days.",
      recordDate: DateTime.now().subtract(const Duration(days: 2)),
      status: "Recovery",
      doctorName: "Dr. Michael Chen",
    ),
  ];
}
