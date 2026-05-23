import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/prediction_model.dart';
import '../../../../services/prediction_service.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'widgets/scan_card_widget.dart';

class AdminScansScreen extends ConsumerWidget {
  const AdminScansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the stream provider instead of calling the method directly
    final scansAsync = ref.watch(allPredictionsStreamProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: "All System Scans"),
      body: scansAsync.when(
        data: (scans) {
          if (scans.isEmpty) {
            return const Center(child: Text('No scans found in the system.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              return ScanCardWidget(scan: scans[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
