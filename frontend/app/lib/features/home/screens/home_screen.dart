import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: const Center(
        child: Text(
          "Welcome to Research AI Assistant 🚀",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
