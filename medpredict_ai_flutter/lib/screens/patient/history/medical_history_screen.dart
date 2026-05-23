import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../configurations/theme/app_colors.dart';
import '../../../../configurations/theme/app_typography.dart';
import '../../../../services/prediction_service.dart';
import '../../../../services/auth_service.dart';
import 'widgets/prediction_timeline_item.dart';

class MedicalHistoryScreen extends ConsumerWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Medical History"),
        body: const Center(
          child: Text("Please log in to view your history"),
        ),
      );
    }

    // Use the stream provider instead of calling the method directly
    final predictionsAsync = ref.watch(userPredictionsStreamProvider(user.uid));

    return Scaffold(
      appBar: const CustomAppBar(title: "Medical History"),
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Scans",
                    style: AppTypography.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  predictionsAsync.when(
                    data: (predictions) {
                      return Text(
                        "You have ${predictions.length} past records.",
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                    loading: () => Text(
                      "Loading...",
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    error: (_, __) => Text(
                      "Unable to load records",
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: predictionsAsync.when(
              data: (predictions) {
                if (predictions.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.no_accounts,
                              size: 64,
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No scans yet",
                              style: AppTypography.textTheme.titleLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Upload your first X-ray to get started",
                              style: AppTypography.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return PredictionTimelineItem(
                        prediction: predictions[index],
                        isLast: index == predictions.length - 1,
                      );
                    },
                    childCount: predictions.length,
                  ),
                );
              },
              loading: () => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          "Error loading history",
                          style: AppTypography.textTheme.titleLarge?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
