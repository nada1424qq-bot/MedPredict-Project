import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medpredict_ai_flutter/configurations/api_config.dart';
import 'dart:io';
import '../../../../../configurations/theme/app_colors.dart';
import '../../../../../configurations/theme/app_typography.dart';
import '../../../../../models/prediction_model.dart';
import '../../../../../models/enums/prediction_result.dart';
import '../../../../../models/enums/risk_level.dart';

class ScanCardWidget extends StatelessWidget {
  final PredictionModel scan;

  const ScanCardWidget({Key? key, required this.scan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPneumonia = scan.result == PredictionResult.PNEUMONIA;
    final formattedDate =
        DateFormat('MMM dd, yyyy - hh:mm a').format(scan.predictionDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Status and Risk Level
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isPneumonia
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.secondary.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isPneumonia
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color:
                          isPneumonia ? AppColors.error : AppColors.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      scan.result.displayName,
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        color:
                            isPneumonia ? AppColors.error : AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (scan.riskLevel != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRiskColor(scan.riskLevel!).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      scan.riskLevel!.displayName,
                      style: TextStyle(
                        color: _getRiskColor(scan.riskLevel!),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Body: Image and Data
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // X-Ray Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: _buildImagePreview(),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(
                        icon: Icons.person_outline,
                        label: 'Patient ID',
                        value: scan.userId.isNotEmpty
                            ? scan.userId.substring(0, 8) + '...'
                            : 'Unknown',
                      ),
                      const SizedBox(height: 8),
                      _DetailRow(
                        icon: Icons.analytics_outlined,
                        label: 'Confidence',
                        value:
                            '${(scan.confidenceScore * 100).toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 8),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: formattedDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    // Use imageUrl from server if available (preferred)
    if (ApiConfig.getImageUrlForDisplay(scan.imageUrl).isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: ApiConfig.getImageUrlForDisplay(scan.imageUrl),
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported),
        ),
      );
    }
    
    // Fallback to local path
    if (scan.imagePath.startsWith('assets/')) {
      return Image.asset(
        scan.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (ctx, _, __) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported),
        ),
      );
    } else if (scan.imagePath.startsWith('http')) {
      return Image.network(
        scan.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (ctx, _, __) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported),
        ),
      );
    } else if (scan.imagePath.isNotEmpty) {
      final file = File(scan.imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (ctx, _, __) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported),
          ),
        );
      }
    }
    
    // No image available
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.hide_image_outlined, color: Colors.grey),
    );
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.MILD:
        return Colors.orange;
      case RiskLevel.MODERATE:
        return Colors.deepOrange;
      case RiskLevel.SEVERE:
        return AppColors.error;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
