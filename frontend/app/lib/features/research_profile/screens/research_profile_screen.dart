import 'package:flutter/material.dart';

import '../../../models/research_profile_model.dart';
import '../../../services/research_profile_service.dart';

class ResearchProfileScreen extends StatefulWidget {
  const ResearchProfileScreen({super.key});

  @override
  State<ResearchProfileScreen> createState() => _ResearchProfileScreenState();
}

class _ResearchProfileScreenState extends State<ResearchProfileScreen> {
  ResearchProfileModel? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    await ResearchProfileService.loadProfile();

    setState(() {
      profile = ResearchProfileService.currentProfile;
    });
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

  Widget infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.isEmpty ? "Not added yet" : value,
                  style: const TextStyle(color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget section({
    required String title,
    required List<String> items,
    required IconData icon,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          items.isEmpty
              ? const Text(
                  "No information added yet.",
                  style: TextStyle(color: Colors.white60),
                )
              : Wrap(children: items.map(tagChip).toList()),
        ],
      ),
    );
  }

  Widget profileHeader(ResearchProfileModel p) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withOpacity(0.25),
            secondary.withOpacity(0.15),
            Theme.of(context).cardColor,
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: primary,
            child: Text(
              p.name.isEmpty ? "R" : p.name.substring(0, 1),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            p.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            p.department,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            p.university,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 16),
          Text(
            p.bio,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, height: 1.55),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = profile;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Research Profile"),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Edit profile screen coming next."),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: p == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                profileHeader(p),

                const SizedBox(height: 22),

                infoCard(
                  icon: Icons.location_on_outlined,
                  title: "Location",
                  value: p.location,
                ),

                infoCard(
                  icon: Icons.search,
                  title: "Looking For",
                  value: p.lookingFor,
                ),

                infoCard(
                  icon: Icons.email_outlined,
                  title: "Email",
                  value: p.email,
                ),

                section(
                  title: "Research Interests",
                  items: p.researchInterests,
                  icon: Icons.psychology_outlined,
                ),

                section(title: "Skills", items: p.skills, icon: Icons.code),

                section(
                  title: "Publications",
                  items: p.publications,
                  icon: Icons.article_outlined,
                ),

                section(
                  title: "Projects",
                  items: p.projects,
                  icon: Icons.work_outline,
                ),

                infoCard(
                  icon: Icons.school_outlined,
                  title: "Google Scholar",
                  value: p.googleScholar,
                ),

                infoCard(icon: Icons.link, title: "GitHub", value: p.github),

                infoCard(
                  icon: Icons.business_center_outlined,
                  title: "LinkedIn",
                  value: p.linkedIn,
                ),
              ],
            ),
    );
  }
}
