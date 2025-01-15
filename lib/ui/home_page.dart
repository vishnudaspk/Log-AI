import 'dart:ui';

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
        backgroundColor: const Color.fromARGB(255, 198, 180, 180),
        title: const Text('Logger App', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          // Log when AddToLogButton is displayed
          AddToLogButton(),
          SizedBox(height: 8),
          // Log when SummarizeButton is displayed
          SummarizeButton(),
          SizedBox(height: 8),
          // Log when LogHistoryButton is displayed
          LogHistoryButton(),
        ],
      ),
    );
  }
}
