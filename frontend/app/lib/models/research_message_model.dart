class ResearchMessageModel {
  final String researcherName;
  final String message;
  final bool isMe;
  final String timeAgo;

  ResearchMessageModel({
    required this.researcherName,
    required this.message,
    required this.isMe,
    required this.timeAgo,
  });
}
