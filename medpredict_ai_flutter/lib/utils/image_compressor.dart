import 'dart:io';
import 'package:image/image.dart' as img;

/// Utility class for image compression
class ImageCompressor {
  /// Compress an image file to reduce size while maintaining quality
  ///
  /// Parameters:
  /// - [file]: The original image file
  /// - [maxWidth]: Maximum width (default: 1024)
  /// - [maxHeight]: Maximum height (default: 1024)
  /// - [quality]: JPEG quality (1-100, default: 85)
  ///
  /// Returns the compressed file
  static Future<File> compressImage(
    File file, {
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  }) async {
    try {
      // Read the image bytes
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize if necessary (maintain aspect ratio)
      img.Image resized = image;
      if (image.width > maxWidth || image.height > maxHeight) {
        resized = img.copyResize(
          image,
          width: image.width > maxWidth ? maxWidth : null,
          height: image.height > maxHeight ? maxHeight : null,
          maintainAspect: true,
        );
      }

      // Encode as JPEG with specified quality
      final compressedBytes = img.encodeJpg(resized, quality: quality);

      // Create new file with .jpg extension
      final compressedFile = File('${file.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }

  /// Get image file size in MB
  static double getFileSizeMb(File file) {
    return file.lengthSync() / (1024 * 1024);
  }

  /// Check if file is an image
  static bool isImageFile(File file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif') ||
        path.endsWith('.bmp') ||
        path.endsWith('.webp');
  }
}
