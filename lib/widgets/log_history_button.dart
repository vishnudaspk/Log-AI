import 'package:flutter/material.dart';
import '../ui/log_history_page.dart';

class LogHistoryButton extends StatelessWidget {
  const LogHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        debugPrint('LogHistoryButton pressed. Navigating to LogHistoryPage.');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LogHistoryPage()),
        );
      },
      icon: const Icon(Icons.history),
      label: const Text('Log History'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(90, 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
