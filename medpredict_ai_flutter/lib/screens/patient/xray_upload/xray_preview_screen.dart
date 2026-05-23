import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../configurations/theme/app_colors.dart';
import '../../../../configurations/theme/app_typography.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../services/prediction_service.dart';
import '../../../../services/auth_service.dart';

class XrayPreviewScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const XrayPreviewScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  ConsumerState<XrayPreviewScreen> createState() => _XrayPreviewScreenState();
}

class _XrayPreviewScreenState extends ConsumerState<XrayPreviewScreen> {
  bool _isAnalyzing = false;
  String? _errorMessage;

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      
    });

    try {
      // Get current user
      final auth = ref.read(authServiceProvider);
      final user = auth.currentUser;

      if (user == null) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'You must be logged in to analyze X-rays';
        });
        return;
      }

      // Upload and get prediction from API
      final result = await ref.read(predictionServiceProvider).uploadXray(
            widget.imagePath,
            user.uid,
          );

      if (mounted) {
        setState(() => _isAnalyzing = false);
        context.pushReplacement('/prediction_result', extra: result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Preview"),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Is this image clear?",
                  style: AppTypography.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Ensure the chest area is fully visible and not blurry.",
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: AppColors.error, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Analyze Image",
                  onPressed: _analyzeImage,
                  isLoading: _isAnalyzing,
                ),
                const SizedBox(height: 16),
                if (!_isAnalyzing)
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      "Retake Photo",
                      style: AppTypography.textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
