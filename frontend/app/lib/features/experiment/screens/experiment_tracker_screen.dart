import 'package:flutter/material.dart';

class ExperimentTrackerScreen extends StatefulWidget {
  const ExperimentTrackerScreen({super.key});

  @override
  State<ExperimentTrackerScreen> createState() =>
      _ExperimentTrackerScreenState();
}

class _ExperimentTrackerScreenState extends State<ExperimentTrackerScreen> {
  final experimentController = TextEditingController();
  final List<String> experiments = [];

  void addExperiment() {
    final text = experimentController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      experiments.add(text);
      experimentController.clear();
    });
  }

  void deleteExperiment(int index) {
    setState(() {
      experiments.removeAt(index);
    });
  }

  @override
  void dispose() {
    experimentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Experiment Tracker"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: experimentController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Experiment name / result",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addExperiment,
                child: const Text("Add Experiment"),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: experiments.isEmpty
                  ? const Center(
                      child: Text(
                        "No experiments added yet.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: experiments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFF1E293B),
                          child: ListTile(
                            title: Text(
                              experiments[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteExperiment(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
