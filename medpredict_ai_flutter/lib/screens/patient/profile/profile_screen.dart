import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../configurations/theme/app_colors.dart';
import '../../../../configurations/theme/app_typography.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/user_service.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final authService = ref.read(authServiceProvider);
    final userService = ref.read(userServiceProvider);
    final user = authService.currentUser;
    if (user != null) {
      _userFuture = userService.getUser(user.uid);
    } else {
      _userFuture = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Profile"),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found. Please login.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.fullName,
                        style: AppTypography.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.phone, // Adding phone just in case
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Settings List
                _buildProfileOption(
                  context,
                  icon: Icons.edit_outlined,
                  title: "Edit Profile",
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UpdateProfileScreen(user: user)),
                    );
                    if (result == true) {
                      setState(() {
                        _loadUser(); // Refresh data
                      });
                    }
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  onTap: () {},
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.lock_outline,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {},
                ),

                const SizedBox(height: 32),
                CustomButton(
                  text: "Logout",
                  onPressed: () async {
                    await ref.read(authServiceProvider).logout();
                    if (context.mounted) context.go('/login');
                  },
                  isOutlined: true,
                  textColor: AppColors.error,
                  // borderColor: AppColors.error,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTypography.textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      onTap: onTap,
    );
  }
}
