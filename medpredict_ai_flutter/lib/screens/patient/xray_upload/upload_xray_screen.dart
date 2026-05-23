import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../configurations/theme/app_colors.dart';
import '../../../../configurations/theme/app_typography.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'widgets/image_picker_widget.dart';

class UploadXrayScreen extends StatefulWidget {
  const UploadXrayScreen({Key? key}) : super(key: key);

  @override
  State<UploadXrayScreen> createState() => _UploadXrayScreenState();
}

class _UploadXrayScreenState extends State<UploadXrayScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null && mounted) {
        context.push('/xray_preview', extra: image.path);
      }
    } catch (e) {
      // Handle permission errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Upload X-ray"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Start Analysis",
              style: AppTypography.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Please upload a clear chest X-ray image for analysis. Ensure the image is well-lit and focused.",
              style: AppTypography.textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.divider,
                  style: BorderStyle.solid,
                  width: 1,
                ), // Dotted border ideally
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 60,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Select an option below",
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ImagePickerWidget(
              onCameraTap: () => _pickImage(ImageSource.camera),
              onGalleryTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
