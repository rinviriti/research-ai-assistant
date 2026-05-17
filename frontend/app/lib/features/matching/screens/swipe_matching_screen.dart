import 'package:flutter/material.dart';

import '../../../models/researcher_model.dart';
import '../../../services/swipe_match_service.dart';

class SwipeMatchingScreen extends StatefulWidget {
  const SwipeMatchingScreen({super.key});

  @override
  State<SwipeMatchingScreen> createState() => _SwipeMatchingScreenState();
}

class _SwipeMatchingScreenState extends State<SwipeMatchingScreen> {
  late List<ResearcherModel> researchers;

  @override
  void initState() {
    super.initState();
    researchers = SwipeMatchService.getAvailableResearchers();
  }

  void refreshResearchers() {
    setState(() {
      researchers = SwipeMatchService.getAvailableResearchers();
    });
  }

  void likeResearcher(ResearcherModel researcher) {
    SwipeMatchService.likeResearcher(researcher);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You showed interest in ${researcher.name} 🚀")),
    );

    refreshResearchers();
  }

  void skipResearcher(ResearcherModel researcher) {
    SwipeMatchService.skipResearcher(researcher);
    refreshResearchers();
  }

  void resetSwipes() {
    SwipeMatchService.resetSwipes();
    refreshResearchers();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Swipe matches reset.")));
  }

  Widget tagChip(String text) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
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
            Icon(Icons.manage_search, color: primary, size: 86),
            const SizedBox(height: 20),
            const Text(
              "No more researchers",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You have reviewed all available researcher profiles. Reset swipes to explore them again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: resetSwipes,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Swipes"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget researcherCard(ResearcherModel researcher) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final matchScore = SwipeMatchService.calculateMatchScore(researcher);

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withOpacity(0.22),
            secondary.withOpacity(0.12),
            Theme.of(context).cardColor,
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: primary,
                child: Text(
                  researcher.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      researcher.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      researcher.university,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      researcher.department,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: primary.withOpacity(0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "$matchScore% Research Compatibility",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Text(
            researcher.bio,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.55,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            "Research Interests",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(children: researcher.interests.map(tagChip).toList()),

          const SizedBox(height: 18),

          const Text(
            "Skills",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(children: researcher.skills.map(tagChip).toList()),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    researcher.lookingFor,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: () => skipResearcher(researcher),
                    icon: const Icon(Icons.close),
                    label: const Text("Skip"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () => likeResearcher(researcher),
                    icon: const Icon(Icons.favorite),
                    label: const Text("Interested"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget matchStatsHeader() {
    final primary = Theme.of(context).colorScheme.primary;
    final totalMatches = SwipeMatchService.matches.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(Icons.favorite, color: primary, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$totalMatches interested match${totalMatches == 1 ? "" : "es"} saved",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: resetSwipes,
            icon: const Icon(Icons.refresh),
            label: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentResearcher = researchers.isNotEmpty ? researchers.first : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Swipe Match")),
      body: currentResearcher == null
          ? emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Research Swipe Match",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Discover supervisors, collaborators, and research friends based on academic interests.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 24),
                matchStatsHeader(),
                researcherCard(currentResearcher),
              ],
            ),
    );
  }
}
