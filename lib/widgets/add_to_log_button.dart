import 'package:flutter/material.dart';
import '../database/ledger_db.dart';

class AddToLogButton extends StatelessWidget {
  const AddToLogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        debugPrint('AddToLogButton pressed. Prompting user for log input.');

        // Prompt the user to input the log
        final log = await showDialog<String>(
          context: context,
          builder: (context) {
            String input = '';
            return AlertDialog(
              title: const Text('Add Log'),
              content: TextField(
                onChanged: (value) {
                  input = value;
                  debugPrint('User input: $input'); // Log the user input
                },
                decoration: const InputDecoration(hintText: 'Enter your log'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    debugPrint(
                        'User submitted log: $input'); // Log when the user submits the input
                    Navigator.pop(context, input);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );

        if (log != null && log.isNotEmpty) {
          debugPrint('Inserting log into database: $log');
          await LedgerDB.insertLog(log);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log added successfully')),
          );
        } else {
          debugPrint('No log entered or input was empty.');
        }
      },
      child: const Text('Add to Log'),
    );
  }
}
