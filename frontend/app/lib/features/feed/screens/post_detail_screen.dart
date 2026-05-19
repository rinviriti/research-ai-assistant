import 'package:flutter/material.dart';

import '../../../backend/backend_provider.dart';
import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../../services/comment_service.dart';
import '../../../services/post_service.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final commentController = TextEditingController();
  final quoteController = TextEditingController();

  PostModel? post;
  CommentModel? replyingTo;

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
    loadPost();
  }

  void loadPost() {
    post = PostService.getPostById(widget.postId);
  }

  @override
  void dispose() {
    commentController.dispose();
    quoteController.dispose();
    super.dispose();
  }

  void addCommentOrReply() {
    final text = commentController.text.trim();

    if (text.isEmpty || post == null) return;

    if (replyingTo == null) {
      CommentService.addComment(
        postId: post!.postId,
        commenter: "You",
        comment: text,
      );
    } else {
      CommentService.addReply(
        postId: post!.postId,
        parentCommentId: replyingTo!.commentId,
        commenter: "You",
        reply: text,
      );
    }

    commentController.clear();

    setState(() {
      replyingTo = null;
      loadPost();
    });
  }

  void startReply(CommentModel comment) {
    setState(() {
      replyingTo = comment;
      commentController.text = "@${comment.commenter} ";
    });
  }

  void cancelReply() {
    setState(() {
      replyingTo = null;
      commentController.clear();
    });
  }

  void setReaction(String reactionType) {
    if (post == null) return;

    PostService.setReaction(postId: post!.postId, reactionType: reactionType);

    setState(() {
      loadPost();
    });
  }

  void showShareSheet() {
    final currentPost = post;

    if (currentPost == null) return;

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
                      currentPost.author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentPost.content,
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
                      post: currentPost,
                      sharedBy: "You",
                      quote: quoteController.text.trim(),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    setState(() {
                      loadPost();
                    });

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

  void showReactionPicker() {
    final currentPost = post;

    if (currentPost == null) return;

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
                  final isSelected =
                      currentPost.currentReaction == reactionType;

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pop(context);
                      setReaction(reactionType);
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

  Widget reactionSummary(PostModel currentPost) {
    final activeReactions = reactionTypes
        .where((reactionType) => (currentPost.reactions[reactionType] ?? 0) > 0)
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
          "${PostService.totalReactions(currentPost)}",
          style: const TextStyle(color: Colors.white60),
        ),
      ],
    );
  }

  String reactionButtonLabel(PostModel currentPost) {
    if (currentPost.currentReaction.isEmpty) return "React";
    return PostService.reactionLabel(currentPost.currentReaction);
  }

  IconData reactionButtonIcon(PostModel currentPost) {
    if (currentPost.currentReaction == "support") return Icons.favorite;
    if (currentPost.currentReaction == "celebrate") return Icons.celebration;
    if (currentPost.currentReaction == "insightful") return Icons.lightbulb;
    if (currentPost.currentReaction == "applaud") return Icons.back_hand;
    if (currentPost.currentReaction == "like") return Icons.thumb_up;
    return Icons.thumb_up_outlined;
  }

  Color reactionButtonColor(PostModel currentPost) {
    if (currentPost.currentReaction.isEmpty) return Colors.white60;
    if (currentPost.currentReaction == "support") return Colors.redAccent;
    if (currentPost.currentReaction == "celebrate") return Colors.amber;
    if (currentPost.currentReaction == "insightful") {
      return Colors.lightBlueAccent;
    }
    if (currentPost.currentReaction == "applaud") return Colors.greenAccent;
    return Colors.blueAccent;
  }

  Widget postCard(PostModel currentPost) {
    final primary = Theme.of(context).colorScheme.primary;
    final commentCount = CommentService.commentCount(currentPost.postId);

    return FutureBuilder<int>(
      future: BackendProvider.shares.shareCount(currentPost.postId),
      builder: (context, snapshot) {
        final shareCount = snapshot.data ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: primary,
                    child: Text(
                      currentPost.author.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPost.author,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          currentPost.university,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
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
                      color: primary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currentPost.type,
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                currentPost.content,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.55,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(children: currentPost.tags.map(tagChip).toList()),
              const SizedBox(height: 18),
              Row(
                children: [
                  reactionSummary(currentPost),
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
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setReaction("like"),
                      onLongPress: showReactionPicker,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              reactionButtonIcon(currentPost),
                              color: reactionButtonColor(currentPost),
                              size: 22,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              reactionButtonLabel(currentPost),
                              style: TextStyle(
                                color: reactionButtonColor(currentPost),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.comment_outlined,
                        color: Colors.white60,
                      ),
                      label: const Text(
                        "Comment",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: showShareSheet,
                      icon: const Icon(Icons.repeat, color: Colors.white60),
                      label: const Text(
                        "Share",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
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
        );
      },
    );
  }

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
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget commentTile(CommentModel comment) {
    final replies = CommentService.getRepliesForComment(comment.commentId);

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
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                comment.timeAgo,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(width: 14),
              InkWell(
                onTap: () => startReply(comment),
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
  }

  Widget replyBanner() {
    if (replyingTo == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Replying to ${replyingTo!.commenter}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          InkWell(
            onTap: cancelReply,
            child: const Icon(Icons.close, color: Colors.white60, size: 18),
          ),
        ],
      ),
    );
  }

  Widget commentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          replyBanner(),
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  onPressed: addCommentOrReply,
                  icon: const Icon(Icons.send, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget missingPost() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          "This research post could not be found.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPost = post;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Post")),
      body: currentPost == null
          ? missingPost()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      postCard(currentPost),
                      const Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...CommentService.getCommentsForPost(
                        currentPost.postId,
                      ).map(commentTile),
                    ],
                  ),
                ),
                commentInput(),
              ],
            ),
    );
  }
}
