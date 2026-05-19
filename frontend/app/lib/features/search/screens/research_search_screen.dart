import 'package:flutter/material.dart';

import '../../../backend/backend_provider.dart';
import '../../../models/post_model.dart';
import '../../../models/researcher_model.dart';
import '../../feed/screens/post_detail_screen.dart';

class ResearchSearchScreen extends StatefulWidget {
  const ResearchSearchScreen({super.key});

  @override
  State<ResearchSearchScreen> createState() => _ResearchSearchScreenState();
}

class _ResearchSearchScreenState extends State<ResearchSearchScreen> {
  final searchController = TextEditingController();

  List<PostModel> postResults = [];
  List<ResearcherModel> researcherResults = [];

  bool hasSearched = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> performSearch(String query) async {
    final posts = await BackendProvider.search.searchPosts(query);
    final researchers = await BackendProvider.search.searchResearchers(query);

    if (!mounted) return;

    setState(() {
      postResults = posts;
      researcherResults = researchers;
      hasSearched = query.trim().isNotEmpty;
    });
  }

  Widget searchBox() {
    return TextField(
      controller: searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: performSearch,
      decoration: InputDecoration(
        hintText: "Search posts, tags, authors, researchers...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  searchController.clear();
                  performSearch("");
                },
                icon: const Icon(Icons.close),
              ),
      ),
    );
  }

  Widget postCard(PostModel post) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: post.postId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.author,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.university,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
            const SizedBox(height: 12),
            Wrap(
              children: post.tags.map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "#$tag",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget researcherCard(ResearcherModel researcher) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: primary,
            child: Text(
              researcher.name.substring(0, 1),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  researcher.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  researcher.university,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  researcher.interests.join(", "),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        "$title ($count)",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          "Search for research posts, authors, tags, universities, or collaborators.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
      ),
    );
  }

  Widget noResults() {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          "No results found.",
          style: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalResults = postResults.length + researcherResults.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Search")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Search Research Network",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Find research posts, collaborators, topics, tags, and institutions.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 22),
          searchBox(),
          if (!hasSearched) ...[
            const SizedBox(height: 80),
            emptyState(),
          ] else if (totalResults == 0)
            noResults()
          else ...[
            sectionTitle("Posts", postResults.length),
            ...postResults.map(postCard),
            sectionTitle("Researchers", researcherResults.length),
            ...researcherResults.map(researcherCard),
          ],
        ],
      ),
    );
  }
}
