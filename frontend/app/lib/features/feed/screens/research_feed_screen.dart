import 'package:flutter/material.dart';

import '../../../models/post_model.dart';
import '../../../services/post_service.dart';

class ResearchFeedScreen extends StatefulWidget {
  const ResearchFeedScreen({super.key});

  @override
  State<ResearchFeedScreen> createState() => _ResearchFeedScreenState();
}

class _ResearchFeedScreenState extends State<ResearchFeedScreen> {
  final postController = TextEditingController();

  String selectedType = "Research Question";

  final List<String> postTypes = const [
    "Research Question",
    "Ongoing Research",
    "Publication",
    "Dataset Request",
    "Collaboration Request",
  ];

  void addPost() {
    final content = postController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write something research-related."),
        ),
      );
      return;
    }

    setState(() {
      PostService.posts.insert(
        0,
        PostModel(
          author: "Rinvi Jaman Riti",
          university: "Daffodil International University",
          content: content,
          type: selectedType,
          tags: ["Research", "AI"],
          timeAgo: "Just now",
          likes: 0,
        ),
      );

      postController.clear();
      selectedType = "Research Question";
    });
  }

  Color typeColor(String type) {
    if (type == "Publication") return Colors.greenAccent;
    if (type == "Ongoing Research") return Colors.blueAccent;
    if (type == "Dataset Request") return Colors.orangeAccent;
    if (type == "Collaboration Request") return Colors.purpleAccent;
    return Theme.of(context).colorScheme.primary;
  }

  Widget tagChip(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
        ),
      ),
      child: Text(
        "#$tag",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget createPostCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
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
            "Share Research Update",
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Post research questions, ongoing work, publications, dataset requests, or collaboration ideas.",
            style: TextStyle(color: Colors.white60, height: 1.4),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            value: selectedType,
            dropdownColor: Theme.of(context).cardColor,
            decoration: const InputDecoration(labelText: "Post Type"),
            items: postTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedType = value;
              });
            },
          ),

          const SizedBox(height: 16),

          TextField(
            controller: postController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "What research are you working on?",
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: addPost,
              icon: const Icon(Icons.post_add),
              label: const Text("Post Research Update"),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Only research-related posts are encouraged.",
            style: TextStyle(color: primary.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget postCard(PostModel post) {
    final color = typeColor(post.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
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
                radius: 25,
                backgroundColor: color,
                child: Text(
                  post.author.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${post.university} • ${post.timeAgo}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Text(
                  post.type,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            post.content,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.55,
              fontSize: 14.5,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(children: post.tags.map(tagChip).toList()),

          const SizedBox(height: 14),

          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    post.likes++;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.likes.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Comment",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),

              const SizedBox(width: 24),

              Row(
                children: [
                  Icon(
                    Icons.person_add_alt_1,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Connect",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = PostService.posts;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Feed")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Research Social Feed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Share ongoing research, ask academic questions, discover collaborators, and follow research updates.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),

          const SizedBox(height: 24),

          createPostCard(),

          ...posts.map(postCard),
        ],
      ),
    );
  }
}
