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
  final searchController = TextEditingController();

  String searchQuery = "";
  int? editingIndex;

  List<NoteModel> get filteredNotes {
    if (searchQuery.isEmpty) return NoteService.notes;

    return NoteService.notes.where((note) {
      final query = searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and content.")),
      );
      return;
    }

    if (editingIndex == null) {
      await NoteService.addNote(NoteModel(title: title, content: content));
    } else {
      NoteService.notes[editingIndex!] = NoteModel(
        title: title,
        content: content,
      );
      await NoteService.saveToStorage();
      editingIndex = null;
    }

    titleController.clear();
    contentController.clear();

    setState(() {});
  }

  void startEdit(int filteredIndex) {
    final note = filteredNotes[filteredIndex];
    final originalIndex = NoteService.notes.indexOf(note);

    setState(() {
      editingIndex = originalIndex;
      titleController.text = note.title;
      contentController.text = note.content;
    });
  }

  Future<void> deleteNote(int filteredIndex) async {
    final originalIndex = NoteService.notes.indexOf(
      filteredNotes[filteredIndex],
    );

    await NoteService.deleteNote(originalIndex);
    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = filteredNotes;

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
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Research Note"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveNote,
                child: Text(editingIndex == null ? "Save Note" : "Update Note"),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search notes...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 24),

            notes.isEmpty
                ? const Text(
                    "No research notes found.",
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
                                  onPressed: () => startEdit(index),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
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
