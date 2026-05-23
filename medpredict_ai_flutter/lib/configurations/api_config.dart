/// API Configuration for MedPredict AI backend
class ApiConfig {
  /// Base URL for the Flask API
  /// Change this to your server address when deploying
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.56.122.115:5000'
  );

  /// Endpoint paths
  static const String predictEndpoint = '/predict';
  static const String healthEndpoint = '/health';
  static const String imagesEndpoint = '/uploads/images';

  /// Connection timeout in milliseconds
  static const int connectTimeout = 30000; // 30 seconds

  /// Receive timeout in milliseconds
  static const int receiveTimeout = 60000; // 60 seconds

  /// Send timeout in milliseconds
  static const int sendTimeout = 60000; // 60 seconds

  /// Maximum file size for upload (16MB)
  static const int maxFileSize = 16 * 1024 * 1024;

  /// Get full URL for prediction endpoint
  static String get predictUrl => '$baseUrl$predictEndpoint';

  /// Get full URL for health check
  static String get healthUrl => '$baseUrl$healthEndpoint';

  /// Get full URL for an image
  static String getImageUrl(String filename) => '$baseUrl$imagesEndpoint/$filename';

  /// Replace localhost with configured base URL for display
  /// Firebase stores localhost URLs from API, but the app needs the actual server IP
  ///
  /// Example:
  /// - Input:  http://localhost:5000/uploads/images/abc.jpg
  /// - Output: http://192.168.1.8:5000/uploads/images/abc.jpg
  static String getImageUrlForDisplay(String imageUrl) {
    if (imageUrl.contains('localhost:5000')) {
      return imageUrl.replaceFirst('http://localhost:5000', baseUrl);
    }
    if (imageUrl.contains('127.0.0.1:5000')) {
      return imageUrl.replaceFirst('http://127.0.0.1:5000', baseUrl);
    }
    return imageUrl;
  }
}
