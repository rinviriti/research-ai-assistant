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

  Future<void> openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditResearchProfileScreen(),
      ),
    );

    await loadProfile();
  }

  ImageProvider? profileImage() {
    if (profile == null || profile!.profileImagePath.isEmpty) return null;

    try {
      return MemoryImage(base64Decode(profile!.profileImagePath));
    } catch (_) {
      return null;
    }
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
              radius: 58,
              backgroundColor: primary.withOpacity(0.16),
              child: Icon(
                Icons.account_circle_outlined,
                size: 76,
                color: primary,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Create Your Research Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Build your academic identity for researcher matching, collaboration, messaging, and RH+ recommendations.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
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

  Widget statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget profileHeader() {
    final primary = Theme.of(context).colorScheme.primary;
    final image = profileImage();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.45),
                  primary.withOpacity(0.10),
                  Theme.of(context).cardColor,
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -48),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: primary,
                  backgroundImage: image,
                  child: image == null
                      ? const Icon(Icons.person, color: Colors.black, size: 62)
                      : null,
                ),
                const SizedBox(height: 14),
                Text(
                  profile!.name.isEmpty ? "Unnamed Researcher" : profile!.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  profile!.department.isEmpty
                      ? "Department not added"
                      : profile!.department,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  profile!.university.isEmpty
                      ? "University not added"
                      : profile!.university,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      statItem(
                        profile!.researchInterests.length.toString(),
                        "Interests",
                      ),
                      Container(width: 1, height: 38, color: Colors.white12),
                      statItem(profile!.skills.length.toString(), "Skills"),
                      Container(width: 1, height: 38, color: Colors.white12),
                      statItem(
                        profile!.publications.length.toString(),
                        "Publications",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: openEditProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Research Profile"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
                    height: 1.45,
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
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: const Text(
          "No data added yet.",
          style: TextStyle(color: Colors.white54),
        ),
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

  Widget linkCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return infoCard(title: title, value: value, icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: emptyProfile(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: loadProfile,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            profileHeader(),

            sectionTitle("About", Icons.info_outline),

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

            sectionTitle("Research Interests", Icons.psychology_outlined),

            chipList(profile!.researchInterests),

            sectionTitle("Skills", Icons.code),

            chipList(profile!.skills),

            sectionTitle("Academic Work", Icons.article_outlined),

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

            sectionTitle("Academic Links", Icons.link),

            linkCard(
              title: "Email",
              value: profile!.email,
              icon: Icons.email_outlined,
            ),

            linkCard(
              title: "Google Scholar",
              value: profile!.googleScholar,
              icon: Icons.school_outlined,
            ),

            linkCard(title: "GitHub", value: profile!.github, icon: Icons.code),

            linkCard(
              title: "LinkedIn",
              value: profile!.linkedIn,
              icon: Icons.business_center_outlined,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
