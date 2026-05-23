import 'package:medpredict_ai_flutter/models/enums/risk_level.dart';

import '../../../../configurations/api_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../../../../configurations/theme/app_colors.dart';
import '../../../../configurations/theme/app_typography.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../models/prediction_model.dart';
import '../../../../models/enums/prediction_result.dart';
import 'widgets/risk_gauge_widget.dart';
import 'widgets/recommendation_card.dart';

class PredictionResultScreen extends StatelessWidget {
  final PredictionModel prediction;

  const PredictionResultScreen({Key? key, required this.prediction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(title: "Analysis Result", showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (prediction.riskLevel != RiskLevel.MILD)
              RiskGaugeWidget(riskLevel: prediction.riskLevel),
            const SizedBox(height: 24),
            // Display the X-ray image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildImage(),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Prediction",
                    style: AppTypography.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prediction.result.displayName,
                    style: AppTypography.textTheme.displayMedium?.copyWith(
                      color: prediction.result == PredictionResult.PNEUMONIA
                          ? AppColors.error
                          : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Confidence: ${(prediction.confidenceScore * 100).toStringAsFixed(1)}%",
                    style: AppTypography.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a')
                        .format(prediction.predictionDate),
                    style: AppTypography.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Recommendations",
                  style: AppTypography.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            RecommendationCard(
              title: "Consult a Doctor",
              description:
                  "Schedule appointment with a pulmonologist for validation.",
              icon: Icons.medical_services_outlined,
            ),
            const SizedBox(height: 12),
            RecommendationCard(
              title: "Monitor Symptoms",
              description: "Track fever, cough, and shortness of breath daily.",
              icon: Icons.list_alt,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: "Back to Home",
              onPressed: () => context.go('/patient_dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Use imageUrl if available (from server), otherwise use local path
    if (ApiConfig.getImageUrlForDisplay(prediction.imageUrl).isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: ApiConfig.getImageUrlForDisplay(prediction.imageUrl),
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.background,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.background,
          child: const Center(
            child: Icon(Icons.error_outline, color: AppColors.error),
          ),
        ),
      );
    } else if (prediction.imagePath.isNotEmpty) {
      // Fallback to local file
      final file = File(prediction.imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.background,
              child: const Center(
                child: Icon(Icons.error_outline, color: AppColors.error),
              ),
            );
          },
        );
      }
    }
    
    // No image available
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 8),
            Text("Image not available", style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
