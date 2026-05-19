import 'package:flutter/material.dart';

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

  PostModel? post;

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
    super.dispose();
  }

  void addComment() {
    final text = commentController.text.trim();

    if (text.isEmpty || post == null) return;

    CommentService.addComment(
      postId: post!.postId,
      commenter: "You",
      comment: text,
    );

    commentController.clear();

    setState(() {});
  }

  void toggleLike() {
    if (post == null) return;

    PostService.toggleLike(post!.postId);

    setState(() {
      loadPost();
    });
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

  Widget postCard(PostModel p) {
    final primary = Theme.of(context).colorScheme.primary;
    final commentCount = CommentService.commentCount(p.postId);

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
                  p.author.substring(0, 1),
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
                      p.author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      p.university,
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
                  p.type,
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
            p.content,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.55,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 18),

          Wrap(children: p.tags.map(tagChip).toList()),

          const SizedBox(height: 18),

          Row(
            children: [
              Icon(
                Icons.thumb_up,
                color: p.isLiked ? Colors.blueAccent : Colors.white38,
                size: 19,
              ),
              const SizedBox(width: 6),
              Text("${p.likes}", style: const TextStyle(color: Colors.white60)),
              const SizedBox(width: 20),
              const Icon(
                Icons.comment_outlined,
                color: Colors.white38,
                size: 19,
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
              Expanded(
                child: TextButton.icon(
                  onPressed: toggleLike,
                  icon: Icon(
                    p.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: p.isLiked ? Colors.blueAccent : Colors.white60,
                  ),
                  label: Text(
                    p.isLiked ? "Liked" : "Like",
                    style: TextStyle(
                      color: p.isLiked ? Colors.blueAccent : Colors.white60,
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
            ],
          ),
        ],
      ),
    );
  }

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
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),

          const SizedBox(height: 8),

          Text(
            comment.timeAgo,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget commentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              onPressed: addComment,
              icon: const Icon(Icons.send, color: Colors.black),
            ),
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
