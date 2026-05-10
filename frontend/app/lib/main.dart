import 'package:flutter/material.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Research AI Assistant")),
      body: const Center(
        child: Text(
          "Flagship Project Started 🚀",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
