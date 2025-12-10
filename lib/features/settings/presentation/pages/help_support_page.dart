import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, size: 64),
            SizedBox(height: 16),
            Text('Coming Soon', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
