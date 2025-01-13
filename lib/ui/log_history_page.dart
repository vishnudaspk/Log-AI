import 'package:flutter/material.dart';
import '../database/ledger_db.dart';

class LogHistoryPage extends StatelessWidget {
  const LogHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Log when LogHistoryPage is being built
    debugPrint('LogHistoryPage widget is being built.');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
            return const Center(child: Text('No logs available'));
          }

          final logs = snapshot.data!;
          debugPrint(
              'Logs fetched successfully. Displaying ${logs.length} logs.');

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              debugPrint('Displaying log: ${log['timestamp']}');
              return ListTile(
                title: Text(log['log']),
                subtitle: Text(log['timestamp']),
              );
            },
          );
        },
      ),
    );
  }
}
