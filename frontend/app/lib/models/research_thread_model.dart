class ResearchThreadModel {
  final String threadId;
  final String researcherName;
  final String university;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;

  ResearchThreadModel({
    required this.threadId,
    required this.researcherName,
    required this.university,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
  });
}
