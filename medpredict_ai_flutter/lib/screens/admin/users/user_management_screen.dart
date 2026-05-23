import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../configurations/theme/app_colors.dart';
import '../../../../models/user_model.dart';
import '../../../../services/user_service.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'widgets/user_card_widget.dart';
import 'widgets/edit_user_dialog.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersStream = ref.watch(userServiceProvider).streamAllUsers();

    return Scaffold(
      appBar: const CustomAppBar(title: "User Management"),
      body: StreamBuilder<List<UserModel>>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCardWidget(
                user: user,
                onEdit: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => EditUserDialog(user: user),
                  );
                  if (result == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('User updated successfully.')),
                    );
                  }
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: Text(
                          'Are you sure you want to delete ${user.fullName}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await ref
                          .read(userServiceProvider)
                          .deleteUser(user.userId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('User deleted successfully')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Delete failed: $e')),
                        );
                      }
                    }
                  }
                },
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Add User feature coming soon')),
      //     );
      //   },
      //   backgroundColor: AppColors.primary,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}
