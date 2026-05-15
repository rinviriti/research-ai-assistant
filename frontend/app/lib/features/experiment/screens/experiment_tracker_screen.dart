import 'package:flutter/material.dart';

import '../../../models/experiment_model.dart';
import '../../../services/experiment_service.dart';

class ExperimentTrackerScreen extends StatefulWidget {
  const ExperimentTrackerScreen({super.key});

  @override
  State<ExperimentTrackerScreen> createState() =>
      _ExperimentTrackerScreenState();
}

class _ExperimentTrackerScreenState extends State<ExperimentTrackerScreen> {
  final experimentNameController = TextEditingController();

  final modelNameController = TextEditingController();

  final resultController = TextEditingController();

  final notesController = TextEditingController();

  int? editingIndex;

  Future<void> saveExperiment() async {
    final experimentName = experimentNameController.text.trim();

    final modelName = modelNameController.text.trim();

    final result = resultController.text.trim();

    final notes = notesController.text.trim();

    if (experimentName.isEmpty || modelName.isEmpty || result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter experiment name, model, and result."),
        ),
      );

      return;
    }

    if (editingIndex == null) {
      await ExperimentService.addExperiment(
        ExperimentModel(
          experimentName: experimentName,
          modelName: modelName,
          result: result,
          notes: notes,
        ),
      );
    } else {
      ExperimentService.experiments[editingIndex!] = ExperimentModel(
        experimentName: experimentName,
        modelName: modelName,
        result: result,
        notes: notes,
      );

      await ExperimentService.saveToStorage();

      editingIndex = null;
    }

    experimentNameController.clear();
    modelNameController.clear();
    resultController.clear();
    notesController.clear();

    setState(() {});
  }

  void startEdit(int index) {
    final experiment = ExperimentService.experiments[index];

    setState(() {
      editingIndex = index;

      experimentNameController.text = experiment.experimentName;

      modelNameController.text = experiment.modelName;

      resultController.text = experiment.result;

      notesController.text = experiment.notes;
    });
  }

  Future<void> deleteExperiment(int index) async {
    await ExperimentService.deleteExperiment(index);

    setState(() {});
  }

  @override
  void dispose() {
    experimentNameController.dispose();
    modelNameController.dispose();
    resultController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(color: Colors.white70),

        filled: true,
        fillColor: const Color(0xFF1E293B),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final experiments = ExperimentService.experiments;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Experiment Tracker"),

        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            buildTextField(
              label: "Experiment Name",

              controller: experimentNameController,
            ),

            const SizedBox(height: 16),

            buildTextField(
              label: "Model Name",

              controller: modelNameController,
            ),

            const SizedBox(height: 16),

            buildTextField(
              label: "Result / Accuracy",

              controller: resultController,
            ),

            const SizedBox(height: 16),

            buildTextField(
              label: "Notes",

              controller: notesController,

              maxLines: 4,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: saveExperiment,

                child: Text(
                  editingIndex == null ? "Add Experiment" : "Update Experiment",
                ),
              ),
            ),

            const SizedBox(height: 30),

            experiments.isEmpty
                ? const Text(
                    "No experiments added yet.",

                    style: TextStyle(color: Colors.white70),
                  )
                : ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: experiments.length,

                    itemBuilder: (context, index) {
                      final experiment = experiments[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),

                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    experiment.experimentName,

                                    style: const TextStyle(
                                      color: Colors.white,

                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () => startEdit(index),

                                  icon: const Icon(
                                    Icons.edit,

                                    color: Colors.blueAccent,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () => deleteExperiment(index),

                                  icon: const Icon(
                                    Icons.delete,

                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Model: ${experiment.modelName}",

                              style: const TextStyle(color: Colors.white70),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Result: ${experiment.result}",

                              style: const TextStyle(color: Colors.blueAccent),
                            ),

                            if (experiment.notes.isNotEmpty) ...[
                              const SizedBox(height: 10),

                              Text(
                                experiment.notes,

                                style: const TextStyle(
                                  color: Colors.white70,

                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
