import 'package:flutter/material.dart';

import '../../../models/swipe_match_model.dart';
import '../../../services/swipe_match_service.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';

class ResearchMatchesScreen extends StatefulWidget {
  const ResearchMatchesScreen({super.key});

  @override
  State<ResearchMatchesScreen> createState() => _ResearchMatchesScreenState();
}

class _ResearchMatchesScreenState extends State<ResearchMatchesScreen> {
  Widget matchCard(SwipeMatchModel match) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  match.university,
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

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResearchChatDetailScreen(
                    researcherName: match.researcherName,
                    university: match.university,
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            icon: Icon(Icons.chat_bubble_outline, color: primary),
          ),
        ],
      ),
    );
  }

  Widget emptyState() {
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
              "Use Swipe Match to show interest in researchers, supervisors, and collaborators. Your interested matches will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsHeader() {
    final matches = SwipeMatchService.matches;
    final avgScore = matches.isEmpty
        ? 0
        : (matches.map((match) => match.matchScore).reduce((a, b) => a + b) /
                  matches.length)
              .round();

    final primary = Theme.of(context).colorScheme.primary;

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
          Expanded(
            child: Column(
              children: [
                Text(
                  matches.length.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Matches", style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          Expanded(
            child: Column(
              children: [
                Text(
                  "$avgScore%",
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Avg Score",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = SwipeMatchService.matches;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Matches")),
      body: matches.isEmpty
          ? emptyState()
          : ListView(
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
                  "Researchers you liked through swipe matching. These can later become collaborators, friends, or supervisors.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

                statsHeader(),

                ...matches.map(matchCard),
              ],
            ),
    );
  }
}
