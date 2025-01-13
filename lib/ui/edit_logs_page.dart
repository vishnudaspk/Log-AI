import 'package:flutter/material.dart';
import '../database/ledger_db.dart';

class EditLogsPage extends StatefulWidget {
  final Map<String, dynamic> log;

  const EditLogsPage({super.key, required this.log});

  @override
  State<EditLogsPage> createState() => _EditLogsPageState();
}

class _EditLogsPageState extends State<EditLogsPage> {
  late TextEditingController _logController;

  @override
  void initState() {
    super.initState();
    _logController = TextEditingController(text: widget.log['log']);
    // Log the initial data passed to this page
    debugPrint('EditLogsPage initialized with log: ${widget.log}');
  }

  @override
  void dispose() {
    // Log when the page is being disposed
    debugPrint('EditLogsPage disposed.');
    _logController.dispose();
    super.dispose();
  }

  Future<void> _updateLog() async {
    final updatedLog = _logController.text.trim();
    if (updatedLog.isNotEmpty) {
      debugPrint('Attempting to update log: ${widget.log['timestamp']}');
      debugPrint('Updated Log Content: $updatedLog');

      await LedgerDB.updateLog(widget.log['timestamp'], updatedLog);

      debugPrint('Log updated successfully in the database.');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log updated successfully')),
      );
      Navigator.pop(context);
    } else {
      debugPrint('Update failed: Log content is empty.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log cannot be empty.')),
      );
    }
  }

  Future<void> _deleteLog() async {
    debugPrint('Attempting to delete log: ${widget.log['timestamp']}');

    await LedgerDB.deleteLog(widget.log['timestamp']);

    debugPrint('Log deleted successfully from the database.');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log deleted successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Log when the page is built
    debugPrint('Building EditLogsPage widget.');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _logController,
              decoration: const InputDecoration(labelText: 'Edit Log'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateLog,
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _deleteLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
