import 'package:flutter/material.dart';
import '../widgets/add_to_log_button.dart';
import '../widgets/summarize_button.dart';
import '../widgets/log_history_button.dart';
import '../widgets/logout_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('HomePage widget is being built.');

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFF2C2C2C),
        automaticallyImplyLeading: false,
        title: const Text(
          'Logger App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          const LogoutButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Log when AddToLogButton is displayed
            const AddToLogButton(),
            const SizedBox(height: 16),
            // Log when SummarizeButton is displayed
            const SummarizeButton(),
            const SizedBox(height: 16),
            // Log when LogHistoryButton is displayed
            const LogHistoryButton(),
          ],
        ),
      ),
    );
  }
}
