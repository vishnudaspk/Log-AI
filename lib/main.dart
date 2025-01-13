import 'package:flutter/material.dart';
import 'ui/home_page.dart';
// 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

void main() {
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
