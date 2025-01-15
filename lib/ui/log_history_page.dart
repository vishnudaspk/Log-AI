import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/ledger_db.dart';

class LogHistoryPage extends StatefulWidget {
  const LogHistoryPage({super.key});

  @override
  State<LogHistoryPage> createState() => _LogHistoryPageState();
}

class _LogHistoryPageState extends State<LogHistoryPage> {
  @override
  Widget build(BuildContext context) {
    // Log when LogHistoryPage is being built
    debugPrint('LogHistoryPage widget is being built.');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 198, 180, 180),
        title: const Text('Log History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Fetch data from DB
        future: LedgerDB.getAllLogs(),
        builder: (context, snapshot) {
          // Log when the FutureBuilder is awaiting data
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('Fetching log data from database...');
            return const Center(child: CircularProgressIndicator());
          }

          // Log if no data is available in the snapshot
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('No logs available.');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No logs available',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Sort logs by timestamp (latest first)
          final logs = snapshot.data!
            ..sort((a, b) {
              return DateTime.parse(b['timestamp'])
                  .compareTo(DateTime.parse(a['timestamp']));
            });

          debugPrint(
              'Logs fetched successfully. Displaying ${logs.length} logs.');

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final formattedTime = DateFormat('dd MMM yyyy, hh:mm a')
                  .format(DateTime.parse(log['timestamp']));
              debugPrint('Displaying log: ${log['timestamp']}');

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 193, 169, 169),
                    width: 1.0,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.event_note, color: Colors.grey),
                  title: Text(
                    log['log'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(formattedTime),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Delete the log
                      debugPrint(
                          'Deleting log with timestamp: ${log['timestamp']}');
                      await LedgerDB.deleteLog(log['timestamp']);

                      // Optionally, refresh the list after deletion
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Log deleted successfully')));

                      // Refresh the widget by calling setState (you can use StatefulWidget instead of StatelessWidget if needed)
                    },
                  ),
                  tileColor: const Color.fromARGB(255, 229, 215, 215),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
