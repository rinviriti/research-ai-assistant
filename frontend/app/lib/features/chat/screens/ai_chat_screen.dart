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

  String selectedMode = "Research Ideas";

  final List<String> aiModes = const [
    "Research Ideas",
    "Literature Review",
    "Methodology",
    "Paper Summary",
    "Citation Help",
    "Experiment Design",
    "Thesis Guidance",
  ];

  final List<String> quickPrompts = const [
    "Suggest thesis ideas in AI healthcare",
    "Explain this paper simply",
    "Create research methodology",
    "Improve my abstract",
    "Suggest future work",
  ];

  Future<void> sendMessage({String? presetMessage}) async {
    final userMessage = presetMessage ?? messageController.text.trim();

    if (userMessage.isEmpty) return;

    await ChatService.addMessage(
      ChatMessageModel(message: "[$selectedMode] $userMessage", isUser: true),
    );

    setState(() {
      isLoading = true;
      messageController.clear();
    });

    final response = await GeminiService.generateResearchResponse(
      mode: selectedMode,
      userInput: userMessage,
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

    if (!mounted) return;

    setState(() {});
  }

  Widget modeChip(String mode) {
    final selected = selectedMode == mode;
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(mode),
        selected: selected,
        selectedColor: primary,
        backgroundColor: Theme.of(context).cardColor,
        side: BorderSide(color: selected ? primary : Colors.white10),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: isLoading
            ? null
            : (_) {
                setState(() {
                  selectedMode = mode;
                });
              },
      ),
    );
  }

  Widget quickPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        backgroundColor: Theme.of(context).cardColor,
        labelStyle: const TextStyle(color: Colors.white70),
        side: const BorderSide(color: Colors.white10),
        onPressed: isLoading ? null : () => sendMessage(presetMessage: text),
      ),
    );
  }

  Widget messageBubble(ChatMessageModel message) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 330),
        decoration: BoxDecoration(
          color: message.isUser ? primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: message.isUser ? null : Border.all(color: Colors.white10),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isUser ? Colors.black : Colors.white,
            height: 1.5,
            fontWeight: message.isUser ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget loadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "RH+ is thinking...",
              style: TextStyle(color: Colors.white70),
            ),
          ],
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Research Chat"),
        actions: [
          IconButton(
            onPressed: clearChat,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: aiModes.map(modeChip).toList(),
            ),
          ),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: quickPrompts.map(quickPromptChip).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return loadingBubble();
                }

                return messageBubble(messages[index]);
              },
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
                    decoration: InputDecoration(
                      hintText: "Ask in $selectedMode mode...",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    onPressed: isLoading ? null : () => sendMessage(),
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
