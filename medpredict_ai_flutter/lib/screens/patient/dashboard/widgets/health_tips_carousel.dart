import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../configurations/theme/app_colors.dart';
import '../../../../../configurations/theme/app_typography.dart';
import '../../../../../services/prediction_service.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../data/health_tips_data.dart';

class HealthTipsCarousel extends ConsumerWidget {
  const HealthTipsCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return _buildTipsSection(
            context,
            tips: HealthTipsData.defaultTips,
            subtitle: 'Sign in to get personalized tips',
            accentColor: AppColors.primary,
          );
        }
        return _buildForUser(context, ref, user);
      },
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildTipsSection(
        context,
        tips: HealthTipsData.defaultTips,
        subtitle: 'General health tips',
        accentColor: AppColors.primary,
      ),
    );
  }

  Widget _buildForUser(BuildContext context, WidgetRef ref, User user) {
    final latestPrediction =
        ref.watch(latestUserPredictionProvider(user.uid));

    return latestPrediction.when(
      data: (prediction) {
        if (prediction == null) {
          return _buildTipsSection(
            context,
            tips: HealthTipsData.defaultTips,
            subtitle: 'Upload a scan to get personalized tips',
            accentColor: AppColors.primary,
          );
        }

        final tips = HealthTipsData.getTipsForScan(
          prediction.result,
          prediction.riskLevel,
        );
        final color = HealthTipsData.colorForRisk(prediction.riskLevel);
        final resultLabel = prediction.result.displayName;
        final riskLabel = prediction.riskLevel.displayName;

        return _buildTipsSection(
          context,
          tips: tips,
          subtitle: 'Based on your latest scan: $resultLabel — $riskLabel Risk',
          accentColor: color,
        );
      },
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildTipsSection(
        context,
        tips: HealthTipsData.defaultTips,
        subtitle: 'General health tips',
        accentColor: AppColors.primary,
      ),
    );
  }

  Widget _buildTipsSection(
    BuildContext context, {
    required List<HealthTipData> tips,
    required String subtitle,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tips_and_updates, color: accentColor, size: 22),
            const SizedBox(width: 8),
            Text(
              "Health Tips",
              style: AppTypography.textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final tip = tips[index];
              return _TipCard(tip: tip, accentColor: accentColor);
            },
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final HealthTipData tip;
  final Color accentColor;

  const _TipCard({required this.tip, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Colored accent strip on the left
            Container(width: 5, color: accentColor),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tip.category,
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Icon + Title
                    Row(
                      children: [
                        Icon(tip.icon, size: 18, color: accentColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tip.title,
                            style: AppTypography.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Description
                    Expanded(
                      child: Text(
                        tip.description,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
