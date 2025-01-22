import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/ledger_db.dart';

class LogHistoryPage extends StatefulWidget {
  const LogHistoryPage({super.key});

  @override
  State<LogHistoryPage> createState() => _LogHistoryPageState();
}

class _LogHistoryPageState extends State<LogHistoryPage> {
  // Function to show confirmation dialog before deleting log
  Future<void> _showDeleteDialog(BuildContext context, String timestamp) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap 'Yes' or 'Cancel'
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF2C2C2C), // Dark background for dialog
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this log?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                debugPrint('Deleting log with timestamp: $timestamp');
                await LedgerDB.deleteLog(timestamp); // Delete the log

                // Show snackbar after deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log deleted successfully')),
                );
                setState(() {}); // Refresh the widget
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Log when LogHistoryPage is being built
    debugPrint('LogHistoryPage widget is being built.');

    return Scaffold(
      backgroundColor:
          const Color(0xFF1C1C1C), // Dark background for the entire scaffold
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333), // Dark background for appBar
        title: const Text(
          'Log History',
          style: TextStyle(color: Colors.white), // White text for uniformity
        ),
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

          // Handle error case if snapshot has error
          if (snapshot.hasError) {
            debugPrint('Error fetching data: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error, size: 60, color: Colors.red),
                  SizedBox(height: 10),
                  Text(
                    'Error fetching logs',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            );
          }

          // Log if no data is available in the snapshot
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('No logs available.');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_rounded,
                      size: 60, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'No logs available',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Sort logs by timestamp (latest first)
          final logs = List<Map<String, dynamic>>.from(snapshot.data!)
            ..sort((a, b) {
              return DateTime.parse(b['timestamp'])
                  .compareTo(DateTime.parse(a['timestamp']));
            });

          debugPrint(
              'Logs fetched successfully. Displaying ${logs.length} logs.');

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Refresh logs when pulled down
            },
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final formattedTime = DateFormat('dd MMM yyyy, hh:mm a')
                    .format(DateTime.parse(log['timestamp']));
                debugPrint('Displaying log: ${log['timestamp']}');

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Consistent text color
                      ),
                    ),
                    subtitle: Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(context,
                            log['timestamp']); // Show delete confirmation dialog
                      },
                    ),
                    tileColor:
                        const Color(0xFF2C2C2C), // Dark background for tile
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
