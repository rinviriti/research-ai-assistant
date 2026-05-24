import 'package:flutter/material.dart';

import '../../../models/collaborator_recommendation_model.dart';
import '../../../models/research_profile_model.dart';

import '../../../services/ai_recommendation_service.dart';
import '../../../services/research_profile_service.dart';
import '../../../services/researcher_service.dart';

import '../../messaging/screens/research_chat_detail_screen.dart';
import '../../research_profile/screens/research_profile_screen.dart';
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
  ResearchProfileModel? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    await ResearchProfileService.ensureProfile();

    final loadedProfile = ResearchProfileService.currentProfile;

    if (!mounted) return;

    setState(() {
      profile = loadedProfile;
      recommendations = loadedProfile == null
          ? []
          : AiRecommendationService.generateRecommendations(
              profile: loadedProfile,
              researchers: ResearcherService.researchers,
            );
      isLoading = false;
    });
  }

  bool get hasEnoughProfileData {
    if (profile == null) return false;

    return profile!.researchInterests.isNotEmpty && profile!.skills.isNotEmpty;
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

  Future<void> openMyProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResearchProfileScreen()),
    );

    await loadRecommendations();
  }

  Widget profileQualityCard() {
    final primary = Theme.of(context).colorScheme.primary;
    final completion = profile?.completionPercentage.round() ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.16), Theme.of(context).cardColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: primary),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Recommendation Quality",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "$completion%",
                style: TextStyle(
                  color: primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: completion / 100,
              minHeight: 8,
              backgroundColor: Colors.white10,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Your profile interests and skills improve collaborator ranking accuracy.",
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
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
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.researcher.university,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: primary.withOpacity(0.35)),
                ),
                child: Text(
                  "${item.score}%",
                  style: TextStyle(
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget incompleteProfileState() {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_outlined, color: primary, size: 78),
            const SizedBox(height: 20),
            const Text(
              "Complete Your Research Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Add at least one research interest and one skill to generate accurate AI collaborator recommendations.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: openMyProfile,
                icon: const Icon(Icons.edit),
                label: const Text("Update Research Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          "No collaborator recommendations found yet.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text("AI Collaborators")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!hasEnoughProfileData) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text("AI Collaborators")),
        body: incompleteProfileState(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("AI Collaborators")),
      body: recommendations.isEmpty
          ? emptyState()
          : RefreshIndicator(
              onRefresh: loadRecommendations,
              child: ListView(
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
                  profileQualityCard(),
                  ...recommendations.map(recommendationCard),
                ],
              ),
            ),
    );
  }
}
