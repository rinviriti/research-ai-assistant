import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../models/research_profile_model.dart';
import '../../../services/research_profile_service.dart';

import 'edit_research_profile_screen.dart';

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

    if (!mounted) return;

    setState(() {
      profile = ResearchProfileService.currentProfile;
    });
  }

  void openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditResearchProfileScreen(),
      ),
    );

    await loadProfile();
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  value.isEmpty ? "Not added yet" : value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chipList(List<String> items) {
    final primary = Theme.of(context).colorScheme.primary;

    if (items.isEmpty) {
      return const Text(
        "No data added yet.",
        style: TextStyle(color: Colors.white54),
      );
    }

    return Wrap(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.14),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withOpacity(0.30)),
          ),
          child: Text(
            item,
            style: TextStyle(color: primary, fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  Widget emptyProfile() {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: primary.withOpacity(0.18),
              child: Icon(
                Icons.account_circle_outlined,
                size: 70,
                color: primary,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "No Research Profile Yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Create your academic identity to unlock researcher matching, collaboration, messaging, and research networking features.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: openEditProfile,
                icon: const Icon(Icons.add),
                label: const Text("Create Research Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileHeader() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: primary,
            backgroundImage: profile!.profileImagePath.isNotEmpty
                ? MemoryImage(base64Decode(profile!.profileImagePath))
                : null,
            child: profile!.profileImagePath.isEmpty
                ? const Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 65,
                  )
                : null,
          ),
          const SizedBox(height: 18),
          Text(
            profile!.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile!.university,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            profile!.department,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: openEditProfile,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Research Profile"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text("Research Profile")),
        body: emptyProfile(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          profileHeader(),

          sectionTitle("About"),

          infoCard(
            title: "Research Bio",
            value: profile!.bio,
            icon: Icons.description_outlined,
          ),

          infoCard(
            title: "Location",
            value: profile!.location,
            icon: Icons.location_on_outlined,
          ),

          infoCard(
            title: "Looking For",
            value: profile!.lookingFor,
            icon: Icons.search,
          ),

          sectionTitle("Research Interests"),

          chipList(profile!.researchInterests),

          sectionTitle("Skills"),

          chipList(profile!.skills),

          sectionTitle("Academic Work"),

          infoCard(
            title: "Publications",
            value: profile!.publications.join(", "),
            icon: Icons.article_outlined,
          ),

          infoCard(
            title: "Projects",
            value: profile!.projects.join(", "),
            icon: Icons.work_outline,
          ),

          sectionTitle("Academic Links"),

          infoCard(
            title: "Email",
            value: profile!.email,
            icon: Icons.email_outlined,
          ),

          infoCard(
            title: "Google Scholar",
            value: profile!.googleScholar,
            icon: Icons.school_outlined,
          ),

          infoCard(title: "GitHub", value: profile!.github, icon: Icons.code),

          infoCard(
            title: "LinkedIn",
            value: profile!.linkedIn,
            icon: Icons.business_center_outlined,
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
