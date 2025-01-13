import 'package:flutter/material.dart';
import '../ui/log_history_page.dart';

class LogHistoryButton extends StatelessWidget {
  const LogHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        debugPrint('LogHistoryButton pressed. Navigating to LogHistoryPage.');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LogHistoryPage()),
        );
      },
      child: const Text('Log History'),
    );
  }
}
