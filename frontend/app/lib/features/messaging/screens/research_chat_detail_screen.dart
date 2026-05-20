import 'package:flutter/material.dart';

import '../../../models/research_message_model.dart';
import '../../../services/research_messaging_service.dart';

class ResearchChatDetailScreen extends StatefulWidget {
  final String researcherName;
  final String university;

  const ResearchChatDetailScreen({
    super.key,
    required this.researcherName,
    required this.university,
  });

  @override
  State<ResearchChatDetailScreen> createState() =>
      _ResearchChatDetailScreenState();
}

class _ResearchChatDetailScreenState extends State<ResearchChatDetailScreen> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ResearchMessagingService.createThread(
      researcherName: widget.researcherName,
      university: widget.university,
    );

    ResearchMessagingService.markThreadAsRead(widget.researcherName);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    ResearchMessagingService.sendMessage(
      researcherName: widget.researcherName,
      university: widget.university,
      message: text,
      isMe: true,
    );

    messageController.clear();
    scrollToBottom();
  }

  Widget chatHeader() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primary,
            child: Text(
              widget.researcherName.substring(0, 1),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.researcherName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.university,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.circle, color: Colors.greenAccent, size: 11),
          const SizedBox(width: 7),
          const Text(
            "Online",
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget messageBubble(ResearchMessageModel message) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isMe ? primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isMe ? 18 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 18),
          ),
          border: Border.all(
            color: message.isMe ? Colors.transparent : Colors.white10,
          ),
        ),
        child: Column(
          crossAxisAlignment: message.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: message.isMe ? Colors.black : Colors.white70,
                height: 1.4,
                fontWeight: message.isMe ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.timeAgo,
              style: TextStyle(
                color: message.isMe ? Colors.black54 : Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyChat() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          "Start a research conversation with ${widget.researcherName}.",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, height: 1.5),
        ),
      ),
    );
  }

  Widget messageList(List<ResearchMessageModel> messages) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    if (messages.isEmpty) {
      return emptyChat();
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: messages.map(messageBubble).toList(),
    );
  }

  Widget messageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => sendMessage(),
              decoration: const InputDecoration(
                hintText: "Write a research message...",
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResearchMessagingService.markThreadAsRead(widget.researcherName);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Chat")),
      body: Column(
        children: [
          chatHeader(),
          Expanded(
            child: StreamBuilder<List<ResearchMessageModel>>(
              stream: ResearchMessagingService.watchMessages(
                widget.researcherName,
              ),
              initialData: ResearchMessagingService.getMessages(
                widget.researcherName,
              ),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return messageList(messages);
              },
            ),
          ),
          messageInput(),
        ],
      ),
    );
  }
}
