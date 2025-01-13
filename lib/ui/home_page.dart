import 'package:flutter/material.dart';
import '../widgets/add_to_log_button.dart';
import '../widgets/summarize_button.dart';
import '../widgets/log_history_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Log when the HomePage is built
    debugPrint('HomePage widget is being built.');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logger App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Log when AddToLogButton is displayed
            AddToLogButton(),
            SizedBox(height: 20),
            // Log when SummarizeButton is displayed
            SummarizeButton(),
            SizedBox(height: 20),
            // Log when LogHistoryButton is displayed
            LogHistoryButton(),
          ],
        ),
      ),
    );
  }
}
