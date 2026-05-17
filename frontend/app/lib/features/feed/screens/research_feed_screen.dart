import 'package:flutter/material.dart';

import '../../../models/post_model.dart';
import '../../../services/post_service.dart';
import '../../../services/comment_service.dart';
import '../../../services/connection_service.dart';

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

  void connectUser(PostModel post) {
    if (ConnectionService.isConnected(post.author)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request already sent to ${post.author}")),
      );
      return;
    }

    setState(() {
      ConnectionService.sendRequest(
        researcherName: post.author,
        university: post.university,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connection request sent to ${post.author}")),
    );
  }

  void openComments(PostModel post) {
    final commentController = TextEditingController();
    final comments = CommentService.getCommentsForPost(post.author);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            final updatedComments = CommentService.getCommentsForPost(
              post.author,
            );

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 22,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Comments",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: updatedComments.isEmpty
                          ? const Center(
                              child: Text(
                                "No comments yet. Start the discussion.",
                                style: TextStyle(color: Colors.white60),
                              ),
                            )
                          : ListView.builder(
                              itemCount: updatedComments.length,
                              itemBuilder: (context, index) {
                                final comment = updatedComments[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        child: Text(
                                          comment.commenter.substring(0, 1),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${comment.commenter} • ${comment.timeAgo}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              comment.comment,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Write a research comment...",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: IconButton(
                            onPressed: () {
                              final text = commentController.text.trim();

                              if (text.isEmpty) return;

                              CommentService.addComment(
                                postAuthor: post.author,
                                commenter: "Rinvi Jaman Riti",
                                comment: text,
                              );

                              commentController.clear();

                              modalSetState(() {});
                              setState(() {});
                            },
                            icon: const Icon(Icons.send, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color typeColor(String type) {
    if (type == "Publication") return Colors.greenAccent;
    if (type == "Ongoing Research") return Colors.blueAccent;
    if (type == "Dataset Request") return Colors.orangeAccent;
    if (type == "Collaboration Request") return Colors.purpleAccent;
    return Theme.of(context).colorScheme.primary;
  }

  Widget tagChip(String tag) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary.withOpacity(0.35)),
      ),
      child: Text(
        "#$tag",
        style: TextStyle(
          color: primary,
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
              setState(() => selectedType = value);
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
    final commentCount = CommentService.getCommentsForPost(post.author).length;
    final connected = ConnectionService.isConnected(post.author);

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

              InkWell(
                onTap: () => openComments(post),
                child: Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      commentCount == 0 ? "Comment" : "$commentCount Comments",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              InkWell(
                onTap: () => connectUser(post),
                child: Row(
                  children: [
                    Icon(
                      connected ? Icons.check_circle : Icons.person_add_alt_1,
                      color: connected
                          ? Colors.greenAccent
                          : Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      connected ? "Pending" : "Connect",
                      style: TextStyle(
                        color: connected ? Colors.greenAccent : Colors.white70,
                      ),
                    ),
                  ],
                ),
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
