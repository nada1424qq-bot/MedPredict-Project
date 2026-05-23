import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../configurations/theme/app_colors.dart';
import '../../../../../configurations/theme/app_typography.dart';
import '../../../../../services/prediction_service.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../data/health_tips_data.dart';
import '../../../../../models/enums/prediction_result.dart';

class HealthSummaryCard extends ConsumerWidget {
  const HealthSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) return _buildCard(context);
        return _buildDynamic(context, ref, user.uid);
      },
      loading: () => _buildCard(context),
      error: (_, __) => _buildCard(context),
    );
  }

  Widget _buildDynamic(BuildContext context, WidgetRef ref, String uid) {
    final latestPrediction = ref.watch(latestUserPredictionProvider(uid));

    return latestPrediction.when(
      data: (prediction) {
        if (prediction == null) return _buildCard(context);

        final riskColor =
            HealthTipsData.colorForRisk(prediction.riskLevel);
        final statusLabel = HealthTipsData.statusLabel(
            prediction.result, prediction.riskLevel);
        final latestText = prediction.result.displayName;

        return _buildCard(
          context,
          cardColor: riskColor,
          statusText: statusLabel,
          latestText: 'Latest: $latestText',
          icon: prediction.result == PredictionResult.NORMAL
              ? Icons.favorite
              : Icons.warning_amber_rounded,
        );
      },
      loading: () => _buildCard(context),
      error: (_, __) => _buildCard(context),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    Color cardColor = AppColors.primary,
    String statusText = 'Stable',
    String latestText = 'No scans yet',
    IconData icon = Icons.favorite,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Status",
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  statusText,
                  style: AppTypography.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              latestText,
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
