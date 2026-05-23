import 'package:go_router/go_router.dart';
import 'package:medpredict_ai_flutter/screens/patient/dashboard/patient_dashboard_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/email_verification_screen.dart';
import '../../screens/patient/xray_upload/upload_xray_screen.dart';
import '../../screens/patient/xray_upload/xray_preview_screen.dart';
import '../../screens/patient/results/prediction_result_screen.dart';
import '../../screens/patient/history/medical_history_screen.dart';
import '../../screens/admin/dashboard/admin_dashboard_screen.dart';
import '../../screens/admin/users/user_management_screen.dart';
import '../../screens/patient/profile/profile_screen.dart';
import '../../models/prediction_model.dart';

import '../../screens/admin/scans/admin_scans_screen.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/email_verification',
        builder: (context, state) {
          final email = state.extra as String;
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/patient_dashboard',
        builder: (context, state) => const PatientDashboardScreen(),
      ),
      GoRoute(
        path: '/upload_xray',
        builder: (context, state) => const UploadXrayScreen(),
      ),
      GoRoute(
        path: '/xray_preview',
        builder: (context, state) {
          final imagePath = state.extra as String;
          return XrayPreviewScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: '/prediction_result',
        builder: (context, state) {
          final prediction = state.extra as PredictionModel;
          return PredictionResultScreen(prediction: prediction);
        },
      ),
      // Admin Routes
      GoRoute(
        path: '/admin_dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin_scans',
        builder: (context, state) => const AdminScansScreen(),
      ),
      GoRoute(
        path: '/user_management',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const MedicalHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

