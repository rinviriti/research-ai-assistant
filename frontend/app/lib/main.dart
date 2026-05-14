import 'package:flutter/material.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  runApp(const ResearchAIApp());
}

class ResearchAIApp extends StatelessWidget {
  const ResearchAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Research AI Assistant',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
