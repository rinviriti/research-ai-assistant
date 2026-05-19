import 'package:flutter/material.dart';

import '../../../backend/backend_provider.dart';
import '../../../models/saved_post_model.dart';
import 'post_detail_screen.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  List<SavedPostModel> savedPosts = [];

  @override
  void initState() {
    super.initState();
    loadSavedPosts();
  }

  Future<void> loadSavedPosts() async {
    final loaded = await BackendProvider.savedPosts.getSavedPosts();

    if (!mounted) return;

    setState(() {
      savedPosts = loaded;
    });
  }

  Future<void> unsavePost(String postId) async {
    await BackendProvider.savedPosts.unsavePost(postId);
    await loadSavedPosts();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Post removed from saved.")));
  }

  Widget savedPostCard(SavedPostModel savedPost) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: savedPost.postId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    savedPost.postAuthor.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    savedPost.postAuthor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "Unsave",
                  onPressed: () => unsavePost(savedPost.postId),
                  icon: const Icon(Icons.bookmark_remove, color: Colors.amber),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              savedPost.postContent,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              savedPost.timeAgo,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          "No saved posts yet.\nSave research posts from the feed to build your personal research library.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Saved Posts")),
      body: savedPosts.isEmpty
          ? emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Saved Research Posts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your personal research reading and idea library.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 24),
                ...savedPosts.map(savedPostCard),
              ],
            ),
    );
  }
}
