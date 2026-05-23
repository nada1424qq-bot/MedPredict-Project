import 'package:flutter/material.dart';
import '../configurations/theme/app_colors.dart';
import '../configurations/theme/app_typography.dart';
import 'custom_button.dart';

class ErrorDisplayWidget extends StatelessWidget {
  // Renamed to avoid reserved name conflict if any
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              "Oops!",
              style: AppTypography.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
