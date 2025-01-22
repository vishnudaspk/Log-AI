import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'ui/intro_page.dart';
import 'ui/login_page.dart';
import 'services/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Save API key securely
  await SecureStorageService.setApiKey(
      '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');

  debugPrint('Starting the application...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MyApp widget...');
    return MaterialApp(
      title: 'Logger App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroPage(), // Set IntroPage as the first screen
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
