import 'package:flutter/material.dart';

import '../../../backend/backend_provider.dart';
import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../../services/notification_service.dart';

class ResearchFeedScreen extends StatefulWidget {
  const ResearchFeedScreen({super.key});

  @override
  State<ResearchFeedScreen> createState() => _ResearchFeedScreenState();
}

class _ResearchFeedScreenState extends State<ResearchFeedScreen> {
  final postController = TextEditingController();
  final tagController = TextEditingController();
  final commentController = TextEditingController();

  String selectedPostType = "Research Question";

  List<PostModel> posts = [];
  bool isLoading = true;

  final List<String> postTypes = const [
    "Research Question",
    "Ongoing Research",
    "Publication",
    "Dataset Request",
    "Collaboration Request",
    "Experiment Result",
  ];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final loadedPosts = await BackendProvider.posts.getPosts();

    if (!mounted) return;

    setState(() {
      posts = loadedPosts;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    postController.dispose();
    tagController.dispose();
    commentController.dispose();
    super.dispose();
  }

  List<String> parseTags(String text) {
    final tags = text
        .split(",")
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    if (tags.isEmpty) {
      return ["Research"];
    }

    return tags;
  }

  Future<void> createPost() async {
    final content = postController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a research-related post.")),
      );
      return;
    }

    final post = PostModel(
      postId: DateTime.now().millisecondsSinceEpoch.toString(),
      author: "You",
      university: "Your University",
      content: content,
      type: selectedPostType,
      tags: parseTags(tagController.text),
      timeAgo: "Just now",
      likes: 0,
      isLiked: false,
    );

    await BackendProvider.posts.createPost(post);

    NotificationService.addNotification(
      title: "Research Post Created",
      body: "Your new research post was added to the feed.",
      type: "post",
    );

    if (!mounted) return;

    setState(() {
      postController.clear();
      tagController.clear();
      selectedPostType = "Research Question";
    });

    await loadPosts();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Research post published successfully 🚀")),
    );
  }

  Future<void> toggleLike(PostModel post) async {
    await BackendProvider.posts.toggleLike(post.postId);
    await loadPosts();
  }

  void showCommentSheet(PostModel post) {
    commentController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final comments = BackendProvider.comments.getComments(post.postId);

            Widget commentTile(CommentModel comment) {
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.commenter,
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
                    const SizedBox(height: 8),
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }

            return FutureBuilder<List<CommentModel>>(
              future: comments,
              builder: (context, snapshot) {
                final loadedComments = snapshot.data ?? [];

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: Column(
                      children: [
                        Container(
                          width: 55,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Research Discussion",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: loadedComments.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No comments yet. Start the discussion.",
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                )
                              : ListView(
                                  children: loadedComments
                                      .map(commentTile)
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 14),
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
                            const SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: IconButton(
                                onPressed: () async {
                                  final text = commentController.text.trim();

                                  if (text.isEmpty) return;

                                  await BackendProvider.comments.addComment(
                                    postId: post.postId,
                                    commenter: "You",
                                    comment: text,
                                  );

                                  commentController.clear();

                                  setModalState(() {});
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.black,
                                ),
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
      },
    );
  }

  Widget composerCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create Research Post",
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ask a question, share ongoing work, request datasets, or post publication updates.",
            style: TextStyle(color: Colors.white60, height: 1.4),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            value: selectedPostType,
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
                selectedPostType = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: postController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText:
                  "What research question, update, or collaboration idea do you want to share?",
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: tagController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Tags",
              hintText: "Medical Imaging, Deep Learning, Dataset",
              prefixIcon: Icon(Icons.tag),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: createPost,
              icon: const Icon(Icons.send),
              label: const Text("Publish Research Post"),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Only research-related content is encouraged.",
            style: TextStyle(color: primary.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tagChip(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        "#$tag",
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget feedCard(PostModel post) {
    final primary = Theme.of(context).colorScheme.primary;

    return FutureBuilder<int>(
      future: BackendProvider.comments.commentCount(post.postId),
      builder: (context, snapshot) {
        final commentCount = snapshot.data ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: primary,
                      child: Text(
                        post.author.substring(0, 1),
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
                            post.author,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            post.university,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            post.type,
                            style: TextStyle(
                              color: primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.timeAgo,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  post.content,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.55,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(children: post.tags.map(tagChip).toList()),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: post.isLiked ? Colors.blueAccent : Colors.white38,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${post.likes}",
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const SizedBox(width: 18),
                    const Icon(
                      Icons.comment_outlined,
                      color: Colors.white38,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$commentCount comments",
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white10),
                Row(
                  children: [
                    actionButton(
                      icon: post.isLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      label: post.isLiked ? "Liked" : "Like",
                      color: post.isLiked ? Colors.blueAccent : Colors.white60,
                      onTap: () {
                        toggleLike(post);
                      },
                    ),
                    actionButton(
                      icon: Icons.comment_outlined,
                      label: "Comment",
                      color: Colors.white60,
                      onTap: () {
                        showCommentSheet(post);
                      },
                    ),
                    actionButton(
                      icon: Icons.share_outlined,
                      label: "Share",
                      color: Colors.white60,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Share feature coming soon."),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Feed")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Academic Research Community",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Discover publications, research questions, ongoing experiments, and collaborate with researchers worldwide.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 24),
                composerCard(),
                ...posts.map(feedCard),
              ],
            ),
    );
  }
}
