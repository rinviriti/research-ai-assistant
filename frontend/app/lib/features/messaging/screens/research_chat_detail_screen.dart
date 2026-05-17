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

  @override
  void initState() {
    super.initState();

    ResearchMessagingService.createThread(
      researcherName: widget.researcherName,
      university: widget.university,
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      ResearchMessagingService.sendMessage(
        researcherName: widget.researcherName,
        message: text,
      );

      messageController.clear();
    });
  }

  Widget messageBubble(ResearchMessageModel message) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 310),
        decoration: BoxDecoration(
          color: message.isMe ? primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: message.isMe ? null : Border.all(color: Colors.white10),
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
                height: 1.45,
                fontWeight: message.isMe ? FontWeight.w600 : FontWeight.normal,
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

  Widget introCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.university,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Start with a short research introduction or collaboration idea.",
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ResearchMessagingService.getMessages(
      widget.researcherName,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(widget.researcherName)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                introCard(),
                if (messages.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text(
                        "No messages yet. Start the conversation.",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  ),
                ...messages.map(messageBubble),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: const Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
