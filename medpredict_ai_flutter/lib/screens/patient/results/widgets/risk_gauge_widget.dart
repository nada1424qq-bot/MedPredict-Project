import 'package:flutter/material.dart';
import '../../../../../configurations/theme/app_colors.dart';
import '../../../../../configurations/theme/app_typography.dart';
import '../../../../../models/enums/risk_level.dart';

class RiskGaugeWidget extends StatelessWidget {
  final RiskLevel riskLevel;

  const RiskGaugeWidget({Key? key, required this.riskLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    double value;
    String label;

    switch (riskLevel) {
      case RiskLevel.MILD:
        color = AppColors.secondary; // Green
        value = 0.33;
        label = "Mild Risk";
        break;
      case RiskLevel.MODERATE:
        color = AppColors.accent; // Orange
        value = 0.66;
        label = "Moderate Risk";
        break;
      case RiskLevel.SEVERE:
        color = AppColors.error; // Red
        value = 1.0;
        label = "High Risk"; // Mapped from Severe for UX
        break;
    }

    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 15,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                backgroundColor: AppColors.divider.withOpacity(0.3),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.health_and_safety, size: 40, color: color),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: AppTypography.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
