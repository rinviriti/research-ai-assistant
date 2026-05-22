import 'package:flutter/material.dart';

import '../../../models/collaborator_recommendation_model.dart';
import '../../../services/research_profile_service.dart';
import '../../../services/researcher_service.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';
import '../../researchers/screens/researcher_profile_preview_screen.dart';

class AiCollaboratorRecommendationsScreen extends StatefulWidget {
  const AiCollaboratorRecommendationsScreen({super.key});

  @override
  State<AiCollaboratorRecommendationsScreen> createState() =>
      _AiCollaboratorRecommendationsScreenState();
}

class _AiCollaboratorRecommendationsScreenState
    extends State<AiCollaboratorRecommendationsScreen> {
  List<CollaboratorRecommendationModel> recommendations = [];

  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    await ResearchProfileService.ensureProfile();

    final profile = ResearchProfileService.currentProfile;

    if (profile == null) return;

    setState(() {
      recommendations = ResearcherService.recommendCollaborators(profile);
    });
  }

  void openProfile(CollaboratorRecommendationModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearcherProfilePreviewScreen(
          name: item.researcher.name,
          university: item.researcher.university,
          interests: item.researcher.interests,
        ),
      ),
    );
  }

  void openChat(CollaboratorRecommendationModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: item.researcher.name,
          university: item.researcher.university,
        ),
      ),
    );
  }

  Widget recommendationCard(CollaboratorRecommendationModel item) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: primary,
                child: Text(
                  item.researcher.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.researcher.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.researcher.university,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${item.score}%",
                style: TextStyle(
                  color: primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            item.reason,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),

          const SizedBox(height: 12),

          Text(
            item.recommendedAction,
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          Wrap(
            children: [
              ...item.sharedInterests.map(
                (interest) => chip(interest, primary),
              ),
              ...item.sharedSkills.map(
                (skill) => chip(skill, Colors.greenAccent),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => openProfile(item),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text("Profile"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => openChat(item),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Message"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          "Complete your research profile to get AI-ready collaborator recommendations.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("AI Collaborator Recommendations")),
      body: recommendations.isEmpty
          ? emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Recommended Researchers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "AI-ready ranking based on your research interests, skills, and collaboration profile.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 24),
                ...recommendations.map(recommendationCard),
              ],
            ),
    );
  }
}
