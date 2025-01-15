import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'services/secure_storage_service.dart'; // Import the secure storage service

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Save API key securely (only needs to be done once, like on app startup)
  await SecureStorageService.setApiKey(
      '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'); // Use your actual API key

  // Log when the app starts
  debugPrint('Starting the application...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Log when the MyApp widget is being built
    debugPrint('Building MyApp widget...');
    return MaterialApp(
      title: 'Logger App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
