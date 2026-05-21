import 'package:flutter/material.dart';

import '../../../models/swipe_match_model.dart';
import '../../../services/research_messaging_service.dart';
import '../../../services/swipe_match_service.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';
import '../../researchers/screens/researcher_profile_preview_screen.dart';

class ResearchMatchesScreen extends StatelessWidget {
  const ResearchMatchesScreen({super.key});

  void openProfile(BuildContext context, SwipeMatchModel match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearcherProfilePreviewScreen(
          name: match.researcherName,
          university: match.university,
          interests: [
            "Research Collaboration",
            "Academic Networking",
            "${match.matchScore}% Match",
            match.status,
          ],
        ),
      ),
    );
  }

  void openChat(BuildContext context, SwipeMatchModel match) {
    ResearchMessagingService.createThread(
      researcherName: match.researcherName,
      university: match.university,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: match.researcherName,
          university: match.university,
        ),
      ),
    );
  }

  Widget statItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget statsHeader(BuildContext context, List<SwipeMatchModel> matches) {
    final primary = Theme.of(context).colorScheme.primary;

    final avgScore = matches.isEmpty
        ? 0
        : (matches.map((match) => match.matchScore).reduce((a, b) => a + b) /
                  matches.length)
              .round();

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.18), Theme.of(context).cardColor],
        ),
      ),
      child: Row(
        children: [
          statItem(
            value: matches.length.toString(),
            label: "Matches",
            color: primary,
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          statItem(
            value: "$avgScore%",
            label: "Avg Score",
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget matchCard(BuildContext context, SwipeMatchModel match) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openProfile(context, match),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.pinkAccent.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primary,
              child: Text(
                match.researcherName.substring(0, 1),
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
                    match.researcherName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    match.university,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: primary.withOpacity(0.45)),
                    ),
                    child: Text(
                      "${match.matchScore}% Match • ${match.status}",
                      style: TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  tooltip: "View Profile",
                  onPressed: () => openProfile(context, match),
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white60,
                  ),
                ),

                IconButton(
                  tooltip: "Message",
                  onPressed: () => openChat(context, match),
                  icon: Icon(Icons.chat_bubble_outline, color: primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, color: primary, size: 84),

            const SizedBox(height: 20),

            const Text(
              "No matches yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Use Swipe Match to discover researchers, collaborators, supervisors, and academic networking opportunities.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context, List<SwipeMatchModel> matches) {
    if (matches.isEmpty) {
      return emptyState(context);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Interested Research Matches",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Researchers you liked through Swipe Match. These can become future collaborators, research friends, or supervisors.",
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),

        const SizedBox(height: 24),

        statsHeader(context, matches),

        ...matches.map((match) => matchCard(context, match)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Matches")),
      body: StreamBuilder<List<SwipeMatchModel>>(
        stream: SwipeMatchService.matchStream,
        initialData: SwipeMatchService.getMatches(),
        builder: (context, snapshot) {
          final matches = snapshot.data ?? [];

          return content(context, matches);
        },
      ),
    );
  }
}
