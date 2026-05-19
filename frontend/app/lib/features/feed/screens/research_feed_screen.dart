import 'package:flutter/material.dart';

import '../../../backend/backend_provider.dart';
import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../../services/post_service.dart';

class ResearchFeedScreen extends StatefulWidget {
  const ResearchFeedScreen({super.key});

  @override
  State<ResearchFeedScreen> createState() => _ResearchFeedScreenState();
}

class _ResearchFeedScreenState extends State<ResearchFeedScreen> {
  final postController = TextEditingController();
  final tagController = TextEditingController();
  final commentController = TextEditingController();
  final quoteController = TextEditingController();

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

  final List<String> reactionTypes = const [
    "like",
    "support",
    "celebrate",
    "insightful",
    "applaud",
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
    quoteController.dispose();
    super.dispose();
  }

  List<String> parseTags(String text) {
    final tags = text
        .split(",")
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    return tags.isEmpty ? ["Research"] : tags;
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

  Future<void> setReaction(PostModel post, String reactionType) async {
    PostService.setReaction(postId: post.postId, reactionType: reactionType);
    await loadPosts();
  }

  void showReactionPicker(PostModel post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "React to this research post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: reactionTypes.map((reactionType) {
                  final isSelected = post.currentReaction == reactionType;

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      Navigator.pop(context);
                      await setReaction(post, reactionType);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.18)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white10,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            PostService.reactionEmoji(reactionType),
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            PostService.reactionLabel(reactionType),
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white70,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void showShareSheet(PostModel post) {
    quoteController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
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
              const SizedBox(height: 20),
              const Text(
                "Share Research Post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Add your thoughts and repost this research update to your feed.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
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
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quoteController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Add a quote or your research thoughts...",
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await BackendProvider.shares.sharePost(
                      post: post,
                      sharedBy: "You",
                      quote: quoteController.text.trim(),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);
                    await loadPosts();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Post shared to your feed 🚀"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.repeat),
                  label: const Text("Share to Feed"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCommentSheet(PostModel post) {
    commentController.clear();
    CommentModel? replyingTo;

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

            Widget replyTile(CommentModel reply) {
              return Container(
                margin: const EdgeInsets.only(left: 28, top: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.72),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.commenter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      reply.comment,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      reply.timeAgo,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            }

            Widget commentTile(CommentModel comment) {
              return FutureBuilder<List<CommentModel>>(
                future: BackendProvider.comments.getReplies(comment.commentId),
                builder: (context, replySnapshot) {
                  final replies = replySnapshot.data ?? [];

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
                        Row(
                          children: [
                            Text(
                              comment.timeAgo,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 14),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  replyingTo = comment;
                                  commentController.text =
                                      "@${comment.commenter} ";
                                });
                              },
                              child: Text(
                                "Reply",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (replies.isNotEmpty) ...replies.map(replyTile),
                      ],
                    ),
                  );
                },
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
                    height: MediaQuery.of(context).size.height * 0.76,
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
                        if (replyingTo != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.35),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Replying to ${replyingTo!.commenter}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setModalState(() {
                                      replyingTo = null;
                                      commentController.clear();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white60,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: replyingTo == null
                                      ? "Write a research comment..."
                                      : "Write a reply...",
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

                                  if (replyingTo == null) {
                                    await BackendProvider.comments.addComment(
                                      postId: post.postId,
                                      commenter: "You",
                                      comment: text,
                                    );
                                  } else {
                                    await BackendProvider.comments.addReply(
                                      postId: post.postId,
                                      parentCommentId: replyingTo!.commentId,
                                      commenter: "You",
                                      reply: text,
                                    );
                                  }

                                  commentController.clear();

                                  setModalState(() {
                                    replyingTo = null;
                                  });

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
    VoidCallback? onLongPress,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        onLongPress: onLongPress,
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

  Widget reactionSummary(PostModel post) {
    final activeReactions = reactionTypes
        .where((reactionType) => (post.reactions[reactionType] ?? 0) > 0)
        .toList();

    if (activeReactions.isEmpty) {
      return const Text(
        "No reactions yet",
        style: TextStyle(color: Colors.white38),
      );
    }

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: activeReactions.take(3).length * 22,
          child: Stack(
            children: activeReactions.take(3).toList().asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final reactionType = entry.value;

              return Positioned(
                left: index * 18,
                child: Container(
                  height: 24,
                  width: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    PostService.reactionEmoji(reactionType),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "${PostService.totalReactions(post)}",
          style: const TextStyle(color: Colors.white60),
        ),
      ],
    );
  }

  String reactionButtonLabel(PostModel post) {
    if (post.currentReaction.isEmpty) return "React";
    return PostService.reactionLabel(post.currentReaction);
  }

  IconData reactionButtonIcon(PostModel post) {
    if (post.currentReaction == "support") return Icons.favorite;
    if (post.currentReaction == "celebrate") return Icons.celebration;
    if (post.currentReaction == "insightful") return Icons.lightbulb;
    if (post.currentReaction == "applaud") return Icons.back_hand;
    if (post.currentReaction == "like") return Icons.thumb_up;

    return Icons.thumb_up_outlined;
  }

  Color reactionButtonColor(PostModel post) {
    if (post.currentReaction.isEmpty) return Colors.white60;

    if (post.currentReaction == "support") return Colors.redAccent;
    if (post.currentReaction == "celebrate") return Colors.amber;
    if (post.currentReaction == "insightful") return Colors.lightBlueAccent;
    if (post.currentReaction == "applaud") return Colors.greenAccent;

    return Colors.blueAccent;
  }

  Widget feedCard(PostModel post) {
    final primary = Theme.of(context).colorScheme.primary;

    return FutureBuilder<int>(
      future: BackendProvider.comments.commentCount(post.postId),
      builder: (context, commentSnapshot) {
        final commentCount = commentSnapshot.data ?? 0;

        return FutureBuilder<int>(
          future: BackendProvider.shares.shareCount(post.postId),
          builder: (context, shareSnapshot) {
            final shareCount = shareSnapshot.data ?? 0;

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
                        reactionSummary(post),
                        const Spacer(),
                        Text(
                          "$commentCount comments • $shareCount shares",
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Colors.white10),
                    Row(
                      children: [
                        actionButton(
                          icon: reactionButtonIcon(post),
                          label: reactionButtonLabel(post),
                          color: reactionButtonColor(post),
                          onTap: () {
                            setReaction(post, "like");
                          },
                          onLongPress: () {
                            showReactionPicker(post);
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
                          icon: Icons.repeat,
                          label: "Share",
                          color: Colors.white60,
                          onTap: () {
                            showShareSheet(post);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Long press React to choose Support, Celebrate, Insightful, or Applaud.",
                      style: TextStyle(color: Colors.white38, fontSize: 11),
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
