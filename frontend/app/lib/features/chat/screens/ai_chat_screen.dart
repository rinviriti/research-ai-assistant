import 'package:flutter/material.dart';

import '../../../models/chat_message_model.dart';
import '../../../services/chat_service.dart';
import '../../../services/gemini_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final messageController = TextEditingController();
  bool isLoading = false;

  Future<void> sendMessage() async {
    final userMessage = messageController.text.trim();

    if (userMessage.isEmpty) return;

    await ChatService.addMessage(
      ChatMessageModel(message: userMessage, isUser: true),
    );

    setState(() {
      isLoading = true;
      messageController.clear();
    });

    final response = await GeminiService.generateSummary(
      title: "Research Chat Question",
      abstract: userMessage,
    );

    if (!mounted) return;

    await ChatService.addMessage(
      ChatMessageModel(message: response, isUser: false),
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> clearChat() async {
    await ChatService.clearChat();
    setState(() {});
  }

  Widget messageBubble(ChatMessageModel message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.message,
          style: const TextStyle(color: Colors.white, height: 1.5),
        ),
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
    final messages = ChatService.messages;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("AI Research Chat"),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            onPressed: clearChat,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return messageBubble(messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask a research question...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    onPressed: isLoading ? null : sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
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
