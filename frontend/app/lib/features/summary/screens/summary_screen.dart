import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("AI Summary")),
      body: const Center(
        child: Text("Summary Screen", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
