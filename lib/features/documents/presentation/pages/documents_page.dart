import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/animations/smooth_animations.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_outlined),
            onPressed: () => context.go('/documents/upload'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmoothAnimations.slideUp(
              child: Text(
                'Your Documents',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SmoothAnimations.slideUp(
              delay: const Duration(milliseconds: 200),
              child: _buildDocumentsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/documents/upload'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDocumentsList() {
    final documents = [
      {'name': 'T4 Slip 2023.pdf', 'type': 'T4 Slip', 'date': '2024-01-15'},
      {'name': 'T5 Statement.pdf', 'type': 'Investment', 'date': '2024-01-20'},
      {'name': 'Receipts.pdf', 'type': 'Receipts', 'date': '2024-02-01'},
    ];

    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: documents.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final doc = documents[index];
          return ListTile(
            leading: const Icon(
              Icons.description,
              color: AppColors.primary,
            ),
            title: Text(
              doc['name']!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text('${doc['type']} • ${doc['date']}'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show options
              },
            ),
          );
        },
      ),
      ),
    );
  }
}
