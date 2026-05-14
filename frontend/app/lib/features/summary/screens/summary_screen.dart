import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final titleController = TextEditingController();

  final abstractController = TextEditingController();

  String generatedSummary = "";

  bool isLoading = false;

  Future<void> generateSummary() async {
    final title = titleController.text.trim();

    final abstractText = abstractController.text.trim();

    if (title.isEmpty || abstractText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and abstract.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedSummary = "";
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;

      generatedSummary =
          "This paper titled \"$title\" presents an AI-assisted approach for research understanding and structured experimentation. "
          "Based on the provided abstract, the proposed method contributes toward intelligent academic workflow automation and research productivity enhancement.";
    });
  }

  void copySummary() {
    Clipboard.setData(ClipboardData(text: generatedSummary));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary copied to clipboard 🚀")),
    );
  }

  void clearFields() {
    titleController.clear();
    abstractController.clear();

    setState(() {
      generatedSummary = "";
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    abstractController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("AI Summary"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Colors.blueAccent,
                size: 70,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Research Paper Summary",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Generate AI-based summaries from research abstracts.",

                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 35),

            TextField(
              controller: titleController,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                labelText: "Paper Title",

                labelStyle: const TextStyle(color: Colors.white70),

                filled: true,
                fillColor: Colors.white10,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: abstractController,

              maxLines: 6,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                labelText: "Abstract",

                labelStyle: const TextStyle(color: Colors.white70),

                filled: true,
                fillColor: Colors.white10,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,

                    child: ElevatedButton(
                      onPressed: isLoading ? null : generateSummary,

                      child: Text(isLoading ? "Generating..." : "Generate"),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                SizedBox(
                  height: 55,

                  child: ElevatedButton(
                    onPressed: clearFields,

                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            if (isLoading) const Center(child: CircularProgressIndicator()),

            if (generatedSummary.isNotEmpty)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Generated Summary",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: copySummary,

                          icon: const Icon(
                            Icons.copy,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      generatedSummary,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
