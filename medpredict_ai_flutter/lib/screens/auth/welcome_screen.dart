import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../configurations/theme/app_colors.dart';
import '../../configurations/theme/app_typography.dart';
import '../../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder - Using an Icon for now if asset not ready
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child:  Image.asset(
                    'assets/images/medpredict_logo.png',
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "MedPredict AI",
                  style: AppTypography.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Early Detection, Better Outcomes",
                  style: AppTypography.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                CustomButton(
                  text: "Login",
                  onPressed: () => context.push('/login'),
                  backgroundColor: Colors.white,
                  textColor: AppColors.primary,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Register",
                  onPressed: () => context.push('/register'),
                  isOutlined: true,
                  backgroundColor: Colors.white, // Border color for outlined
                  textColor: Colors.white,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
