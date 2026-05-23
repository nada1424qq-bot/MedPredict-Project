import 'package:flutter/material.dart';
import '../models/enums/prediction_result.dart';
import '../models/enums/risk_level.dart';

/// A single health tip entry used in the dashboard carousel.
class HealthTipData {
  final IconData icon;
  final String title;
  final String description;
  final String category;

  const HealthTipData({
    required this.icon,
    required this.title,
    required this.description,
    required this.category,
  });
}

/// Mock health tips keyed by (PredictionResult, RiskLevel).
///
/// These mirror the risk-level logic from the AI model's
/// `calculate_risk_level` method:
///   Normal        → always MILD
///   Pneumonia     → MILD (conf ≤ 0.70), MODERATE (0.70–0.85), SEVERE (> 0.85)
class HealthTipsData {
  HealthTipsData._();

  // ──────────────────────────────────────────────
  //  Scenario 1: Normal / MILD — Preventive wellness
  // ──────────────────────────────────────────────
  static const _normalMild = [
    HealthTipData(
      icon: Icons.directions_run,
      title: 'Stay Active',
      description:
          'Aim for 30 minutes of moderate exercise daily to strengthen your lungs and cardiovascular system.',
      category: 'Prevention',
    ),
    HealthTipData(
      icon: Icons.vaccines,
      title: 'Keep Vaccinations Current',
      description:
          'Annual flu and pneumococcal vaccines significantly reduce respiratory infection risk.',
      category: 'Prevention',
    ),
    HealthTipData(
      icon: Icons.water_drop,
      title: 'Stay Hydrated',
      description:
          'Drink at least 8 glasses of water daily to keep your airways moist and healthy.',
      category: 'Wellness',
    ),
    HealthTipData(
      icon: Icons.calendar_month,
      title: 'Schedule Annual Check-ups',
      description:
          'Regular check-ups help detect early signs of respiratory conditions before symptoms appear.',
      category: 'Prevention',
    ),
    HealthTipData(
      icon: Icons.air,
      title: 'Practice Deep Breathing',
      description:
          'Daily deep-breathing exercises improve lung capacity and oxygen efficiency.',
      category: 'Wellness',
    ),
  ];

  // ──────────────────────────────────────────────
  //  Scenario 2: Pneumonia / MILD — Early-warning monitoring
  // ──────────────────────────────────────────────
  static const _pneumoniaMild = [
    HealthTipData(
      icon: Icons.thermostat,
      title: 'Monitor Temperature',
      description:
          'Check your temperature twice daily. A fever above 38 °C may signal worsening infection.',
      category: 'Monitoring',
    ),
    HealthTipData(
      icon: Icons.local_drink,
      title: 'Increase Fluid Intake',
      description:
          'Hydration thins mucus and supports your immune system. Aim for 10+ glasses of water daily.',
      category: 'Self-Care',
    ),
    HealthTipData(
      icon: Icons.bed,
      title: 'Prioritize Rest',
      description:
          'Your body fights infection most effectively during sleep. Get at least 8 hours per night.',
      category: 'Self-Care',
    ),
    HealthTipData(
      icon: Icons.medical_services_outlined,
      title: 'Consult Your Doctor',
      description:
          'Even mild findings warrant a medical consultation. Schedule a visit within the next week.',
      category: 'Medical',
    ),
    HealthTipData(
      icon: Icons.masks,
      title: 'Protect Others',
      description:
          'Wear a mask in crowded spaces and wash hands frequently to prevent spreading infection.',
      category: 'Prevention',
    ),
  ];

  // ──────────────────────────────────────────────
  //  Scenario 3: Pneumonia / MODERATE — Action-oriented medical
  // ──────────────────────────────────────────────
  static const _pneumoniaModerate = [
    HealthTipData(
      icon: Icons.event_available,
      title: 'Schedule a Follow-Up X-ray',
      description:
          'A repeat chest X-ray within 2 weeks helps track whether the condition is improving or progressing.',
      category: 'Medical',
    ),
    HealthTipData(
      icon: Icons.science,
      title: 'Request a Sputum Culture',
      description:
          'Identifying the specific pathogen enables targeted antibiotic therapy for faster recovery.',
      category: 'Medical',
    ),
    HealthTipData(
      icon: Icons.medication,
      title: 'Complete Your Antibiotics',
      description:
          'If prescribed, finish the full antibiotic course even if you feel better — stopping early risks relapse.',
      category: 'Treatment',
    ),
    HealthTipData(
      icon: Icons.monitor_heart,
      title: 'Track Oxygen Levels',
      description:
          'Use a pulse oximeter daily. Seek immediate care if SpO₂ drops below 94 %.',
      category: 'Monitoring',
    ),
    HealthTipData(
      icon: Icons.no_meals,
      title: 'Avoid Irritants',
      description:
          'Stay away from smoke, dust, and strong fumes — they worsen lung inflammation.',
      category: 'Self-Care',
    ),
  ];

  // ──────────────────────────────────────────────
  //  Scenario 4: Pneumonia / SEVERE — Urgent critical care
  // ──────────────────────────────────────────────
  static const _pneumoniaSevere = [
    HealthTipData(
      icon: Icons.emergency,
      title: 'Seek Emergency Care Now',
      description:
          '⚠️ A severe finding requires immediate medical attention. Visit the nearest emergency room.',
      category: 'Urgent',
    ),
    HealthTipData(
      icon: Icons.phone_in_talk,
      title: 'Contact Your Pulmonologist',
      description:
          'Call your lung specialist today. Do not delay — early specialist intervention is critical.',
      category: 'Urgent',
    ),
    HealthTipData(
      icon: Icons.airline_seat_flat,
      title: 'Rest in Upright Position',
      description:
          'Sitting upright or propped on pillows helps ease breathing and improves oxygen intake.',
      category: 'Self-Care',
    ),
    HealthTipData(
      icon: Icons.monitor_heart_outlined,
      title: 'Continuous Oxygen Monitoring',
      description:
          'Monitor SpO₂ every 2 hours. If it drops below 92 %, call emergency services immediately.',
      category: 'Monitoring',
    ),
    HealthTipData(
      icon: Icons.groups,
      title: 'Arrange a Support Person',
      description:
          'Have a family member or friend nearby to assist you and monitor for sudden changes.',
      category: 'Safety',
    ),
  ];

  // ──────────────────────────────────────────────
  //  Default tips when no scan history exists
  // ──────────────────────────────────────────────
  static const defaultTips = [
    HealthTipData(
      icon: Icons.upload_file,
      title: 'Upload Your First X-ray',
      description:
          'Get personalized health tips by uploading a chest X-ray for AI analysis.',
      category: 'Getting Started',
    ),
    HealthTipData(
      icon: Icons.health_and_safety,
      title: 'Know Your Lung Health',
      description:
          'Our AI analyzes chest X-rays in seconds and provides instant risk assessment.',
      category: 'Information',
    ),
    HealthTipData(
      icon: Icons.shield,
      title: 'Prevention is Key',
      description:
          'Regular screening helps detect respiratory conditions early, when they are most treatable.',
      category: 'Prevention',
    ),
    HealthTipData(
      icon: Icons.directions_run,
      title: 'Stay Active & Healthy',
      description:
          'Daily exercise and good hydration are the foundations of strong respiratory health.',
      category: 'Wellness',
    ),
  ];

  // ──────────────────────────────────────────────
  //  Lookup by prediction result + risk level
  // ──────────────────────────────────────────────

  /// Returns tips matching the given [result] and [riskLevel].
  /// Falls back to [defaultTips] if no match is found.
  static List<HealthTipData> getTipsForScan(
    PredictionResult result,
    RiskLevel riskLevel,
  ) {
    if (result == PredictionResult.NORMAL) {
      return _normalMild;
    }

    // Pneumonia cases
    switch (riskLevel) {
      case RiskLevel.MILD:
        return _pneumoniaMild;
      case RiskLevel.MODERATE:
        return _pneumoniaModerate;
      case RiskLevel.SEVERE:
        return _pneumoniaSevere;
    }
  }

  /// Color accent for the given risk level.
  static Color colorForRisk(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.MILD:
        return const Color(0xFF4CAF50); // Green
      case RiskLevel.MODERATE:
        return const Color(0xFFFF9800); // Orange
      case RiskLevel.SEVERE:
        return const Color(0xFFF44336); // Red
    }
  }

  /// Human-readable health status label.
  static String statusLabel(PredictionResult result, RiskLevel riskLevel) {
    if (result == PredictionResult.NORMAL) return 'Stable';
    switch (riskLevel) {
      case RiskLevel.MILD:
        return 'Monitor';
      case RiskLevel.MODERATE:
        return 'At Risk';
      case RiskLevel.SEVERE:
        return 'Critical';
    }
  }
}
