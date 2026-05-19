class ResearchMessageModel {
  final String messageId;
  final String senderName;
  final String message;
  final String timeAgo;
  final bool isMe;

  ResearchMessageModel({
    required this.messageId,
    required this.senderName,
    required this.message,
    required this.timeAgo,
    required this.isMe,
  });
}
