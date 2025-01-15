import 'package:flutter/material.dart';
import '../database/ledger_db.dart';
import '../database/summary_db.dart';
import '../services/groq_ai_service.dart';

class SummarizeButton extends StatefulWidget {
  const SummarizeButton({super.key});

  @override
  SummarizeButtonState createState() => SummarizeButtonState();
}

class SummarizeButtonState extends State<SummarizeButton> {
  bool _isLoading = false;

  Future<void> _summarizeLogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get today's logs from LedgerDB
      debugPrint('Fetching today\'s logs from LedgerDB...');
      final todayLogs = await LedgerDB.getTodayLogs();

      if (todayLogs.isEmpty) {
        debugPrint('No logs found for today.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No logs found for today.')),
        );
        return;
      }

      // Compile logs into a single JSON string
      final compiledLogs = todayLogs.join('. ');
      debugPrint('Compiled logs: $compiledLogs');

      // Call GROQ AI service to summarize
      debugPrint('Sending logs to GROQ AI service for summarization...');
      final summary = await GroqAIService.summarizeLogs(compiledLogs);

      if (summary != null) {
        debugPrint('Summary received: $summary');

        // Save the summary to SummaryDB
        debugPrint('Saving summary to SummaryDB...');
        await SummaryDB.insertSummary(compiledLogs, summary);

        // Display the summary in a dialog
        debugPrint('Displaying summary in dialog...');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Summary'),
            content: Text(summary),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        debugPrint('Failed to summarize logs.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to summarize logs.')),
        );
      }
    } catch (e) {
      debugPrint('Error during summarization: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred during summarization.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _summarizeLogs,
      icon: const Icon(Icons.summarize),
      label: _isLoading
          ? const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white)
          : const Text('Summarize'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(90, 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
