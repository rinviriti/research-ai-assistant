import 'package:flutter/material.dart';

import '../../../models/note_model.dart';
import '../../../services/note_service.dart';

class ResearchNotesScreen extends StatefulWidget {
  const ResearchNotesScreen({super.key});

  @override
  State<ResearchNotesScreen> createState() => _ResearchNotesScreenState();
}

class _ResearchNotesScreenState extends State<ResearchNotesScreen> {
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  Future<void> addNote() async {
    final title = titleController.text.trim();

    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and content.")),
      );

      return;
    }

    await NoteService.addNote(NoteModel(title: title, content: content));

    titleController.clear();
    contentController.clear();

    setState(() {});
  }

  Future<void> deleteNote(int index) async {
    await NoteService.deleteNote(index);

    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = NoteService.notes;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Research Notes"),

        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            TextField(
              controller: titleController,

              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(labelText: "Note Title"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: contentController,

              maxLines: 6,

              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(labelText: "Research Notes"),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: addNote,

                child: const Text("Save Note"),
              ),
            ),

            const SizedBox(height: 30),

            notes.isEmpty
                ? const Text(
                    "No research notes yet.",

                    style: TextStyle(color: Colors.white70),
                  )
                : ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: notes.length,

                    itemBuilder: (context, index) {
                      final note = notes[index];

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
                                    note.title,

                                    style: const TextStyle(
                                      color: Colors.white,

                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () => deleteNote(index),

                                  icon: const Icon(
                                    Icons.delete,

                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              note.content,

                              style: const TextStyle(
                                color: Colors.white70,

                                height: 1.5,
                              ),
                            ),
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
