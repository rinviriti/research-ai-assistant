import 'package:flutter/material.dart';

import '../../../backend/backend_provider.dart';
import '../../../models/post_model.dart';
import '../../../models/researcher_model.dart';
import '../../../services/connection_service.dart';
import '../../feed/screens/post_detail_screen.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';

class ResearchSearchScreen extends StatefulWidget {
  final bool autoFocus;

  const ResearchSearchScreen({super.key, this.autoFocus = false});

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

  void askToViewProfile(ResearcherModel researcher) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text(
            "View Researcher Profile?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Do you want to view ${researcher.name}'s full research profile?",
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showFullResearcherProfile(researcher);
              },
              child: const Text("View Profile"),
            ),
          ],
        );
      },
    );
  }

  void showFullResearcherProfile(ResearcherModel researcher) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;
        final isConnected = ConnectionService.isConnected(researcher.name);

        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 22),
              CircleAvatar(
                radius: 48,
                backgroundColor: primary,
                child: Text(
                  researcher.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                researcher.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                researcher.university,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60, height: 1.4),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Research Interests",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      children: researcher.interests.map((interest) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8, bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isConnected
                          ? null
                          : () async {
                              await connectResearcher(researcher);
                              if (!mounted) return;
                              Navigator.pop(context);
                            },
                      icon: Icon(
                        isConnected
                            ? Icons.check_circle_outline
                            : Icons.person_add_alt_1,
                      ),
                      label: Text(isConnected ? "Request Sent" : "Connect"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => messageResearcher(researcher),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text("Message"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> connectResearcher(ResearcherModel researcher) async {
    if (ConnectionService.isConnected(researcher.name)) {
      return;
    }

    await BackendProvider.connections.sendRequest(
      researcherName: researcher.name,
      university: researcher.university,
    );

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connection request sent to ${researcher.name}.")),
    );
  }

  Future<void> messageResearcher(ResearcherModel researcher) async {
    await BackendProvider.messaging.createThread(
      researcherName: researcher.name,
      university: researcher.university,
    );

    if (!mounted) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: researcher.name,
          university: researcher.university,
        ),
      ),
    );
  }

  void openResearcherDetails(ResearcherModel researcher) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final isConnected = ConnectionService.isConnected(researcher.name);

            return Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 55,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 22),
                  InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () {
                      askToViewProfile(researcher);
                    },
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: primary,
                      child: Text(
                        researcher.name.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap photo to view profile",
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    researcher.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    researcher.university,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Research Interests",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          children: researcher.interests.map((interest) {
                            return Container(
                              margin: const EdgeInsets.only(
                                right: 8,
                                bottom: 8,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                interest,
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isConnected
                              ? null
                              : () async {
                                  await connectResearcher(researcher);
                                  setModalState(() {});
                                },
                          icon: Icon(
                            isConnected
                                ? Icons.check_circle_outline
                                : Icons.person_add_alt_1,
                          ),
                          label: Text(isConnected ? "Request Sent" : "Connect"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => messageResearcher(researcher),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text("Message"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget searchBox() {
    return TextField(
      controller: searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: performSearch,
      autofocus: widget.autoFocus,
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

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openResearcherDetails(researcher),
      child: Container(
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white30,
              size: 16,
            ),
          ],
        ),
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
