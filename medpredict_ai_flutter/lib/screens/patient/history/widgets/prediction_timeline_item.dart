import '../../../../../configurations/api_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../configurations/theme/app_colors.dart';
import '../../../../../configurations/theme/app_typography.dart';
import '../../../../../models/prediction_model.dart';
import '../../../../../models/enums/prediction_result.dart';

class PredictionTimelineItem extends StatelessWidget {
  final PredictionModel prediction;
  final bool isLast;

  const PredictionTimelineItem({
    Key? key,
    required this.prediction,
    this.isLast = false,
  }) : super(key: key);

  Color _getResultColor(PredictionResult result) {
    switch (result) {
      case PredictionResult.PNEUMONIA:
        return AppColors.error;
      case PredictionResult.NORMAL:
        return AppColors.secondary;
    }
  }

  String _getRiskEmoji(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'severe':
        return '🔴';
      case 'moderate':
        return '🟠';
      case 'mild':
      default:
        return '🟢';
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(prediction.result);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Column
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(prediction.predictionDate),
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(prediction.predictionDate),
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('yyyy').format(prediction.predictionDate),
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Timeline Line Column
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: resultColor, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: resultColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to detail view
                  // TODO: Navigate to prediction detail screen
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: resultColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Preview
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: _buildImage(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Result Badge & Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _getRiskEmoji(prediction.riskLevel.name),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: resultColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        prediction.result.displayName,
                                        style: AppTypography.textTheme
                                            .labelMedium
                                            ?.copyWith(
                                          color: resultColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${(prediction.confidenceScore * 100).toStringAsFixed(0)}%",
                                  style: AppTypography.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Date & Time
                            Text(
                              DateFormat('MMM dd, yyyy • hh:mm a')
                                  .format(prediction.predictionDate),
                              style: AppTypography.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Use imageUrl if available (from server)
    if (ApiConfig.getImageUrlForDisplay(prediction.imageUrl).isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: ApiConfig.getImageUrlForDisplay(prediction.imageUrl),
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.background,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.background,
          child: const Center(
            child: Icon(Icons.error_outline,
              color: AppColors.error,
              size: 32,
            ),
          ),
        ),
      );
    }

    // Placeholder when no image URL
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              prediction.result == PredictionResult.PNEUMONIA
                  ? Icons.sick
                  : Icons.health_and_safety,
              size: 40,
              color: _getResultColor(prediction.result).withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              "Image not available",
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
