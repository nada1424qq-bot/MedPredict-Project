import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../configurations/theme/app_colors.dart';
import '../../../../../configurations/theme/app_typography.dart';
import '../../../../../models/prediction_model.dart';
import '../../../../../models/enums/prediction_result.dart';

class RecentPredictionsList extends StatelessWidget {
  final List<PredictionModel> predictions;

  const RecentPredictionsList({Key? key, required this.predictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Scans",
              style: AppTypography.textTheme.titleLarge,
            ),
            TextButton(
               onPressed: () => context.push('/admin_scans'),
              child: Text("View All"),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: predictions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final prediction = predictions[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(prediction
                        .imagePath), // Ensure mock images exist or use placeholder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                "Patient ID: ${prediction.userId}",
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                prediction.predictionDate.toString().split(' ')[0],
                style: AppTypography.textTheme.bodySmall,
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: prediction.result == PredictionResult.PNEUMONIA
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  prediction.result.displayName,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: prediction.result == PredictionResult.PNEUMONIA
                        ? AppColors.error
                        : AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
