import 'package:flutter/material.dart';

import '../../../models/research_profile_model.dart';
import '../../../services/research_profile_service.dart';

class EditResearchProfileScreen extends StatefulWidget {
  const EditResearchProfileScreen({super.key});

  @override
  State<EditResearchProfileScreen> createState() =>
      _EditResearchProfileScreenState();
}

class _EditResearchProfileScreenState extends State<EditResearchProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final universityController = TextEditingController();
  final departmentController = TextEditingController();
  final bioController = TextEditingController();
  final locationController = TextEditingController();
  final lookingForController = TextEditingController();

  final interestsController = TextEditingController();
  final skillsController = TextEditingController();
  final publicationsController = TextEditingController();
  final projectsController = TextEditingController();

  final googleScholarController = TextEditingController();
  final githubController = TextEditingController();
  final linkedInController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCurrentProfile();
  }

  Future<void> loadCurrentProfile() async {
    await ResearchProfileService.loadProfile();

    final profile =
        ResearchProfileService.currentProfile ??
        ResearchProfileService.defaultProfile;

    nameController.text = profile.name;
    emailController.text = profile.email;
    universityController.text = profile.university;
    departmentController.text = profile.department;
    bioController.text = profile.bio;
    locationController.text = profile.location;
    lookingForController.text = profile.lookingFor;

    interestsController.text = profile.researchInterests.join(", ");
    skillsController.text = profile.skills.join(", ");
    publicationsController.text = profile.publications.join(", ");
    projectsController.text = profile.projects.join(", ");

    googleScholarController.text = profile.googleScholar;
    githubController.text = profile.github;
    linkedInController.text = profile.linkedIn;

    if (mounted) {
      setState(() {});
    }
  }

  List<String> splitList(String text) {
    return text
        .split(",")
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and email are required.")),
      );
      return;
    }

    final updatedProfile = ResearchProfileModel(
      name: name,
      email: email,
      university: universityController.text.trim(),
      department: departmentController.text.trim(),
      bio: bioController.text.trim(),
      location: locationController.text.trim(),
      lookingFor: lookingForController.text.trim(),
      researchInterests: splitList(interestsController.text),
      skills: splitList(skillsController.text),
      publications: splitList(publicationsController.text),
      projects: splitList(projectsController.text),
      googleScholar: googleScholarController.text.trim(),
      github: githubController.text.trim(),
      linkedIn: linkedInController.text.trim(),
    );

    await ResearchProfileService.saveProfile(updatedProfile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Research profile updated successfully 🚀")),
    );

    Navigator.pop(context, true);
  }

  Widget sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hint,
    IconData? icon,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon == null ? null : Icon(icon, color: primary),
        ),
      ),
    );
  }

  Widget helperBox() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "For interests, skills, publications, and projects, separate each item using commas. Example: Medical Imaging, Deep Learning, Flutter",
              style: TextStyle(color: Colors.white70, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    universityController.dispose();
    departmentController.dispose();
    bioController.dispose();
    locationController.dispose();
    lookingForController.dispose();
    interestsController.dispose();
    skillsController.dispose();
    publicationsController.dispose();
    projectsController.dispose();
    googleScholarController.dispose();
    githubController.dispose();
    linkedInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Edit Research Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: primary,
                    child: const Icon(
                      Icons.account_circle,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Build Your Academic Identity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This profile will later be used for researcher matching, collaboration requests, and academic networking.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, height: 1.45),
                  ),
                ],
              ),
            ),

            sectionTitle(
              "Basic Information",
              "Add your academic identity and affiliation.",
            ),

            inputField(
              label: "Full Name",
              controller: nameController,
              icon: Icons.person_outline,
            ),

            inputField(
              label: "Email",
              controller: emailController,
              icon: Icons.email_outlined,
            ),

            inputField(
              label: "University",
              controller: universityController,
              icon: Icons.school_outlined,
            ),

            inputField(
              label: "Department",
              controller: departmentController,
              icon: Icons.apartment_outlined,
            ),

            inputField(
              label: "Location",
              controller: locationController,
              icon: Icons.location_on_outlined,
            ),

            inputField(
              label: "Bio",
              controller: bioController,
              maxLines: 4,
              hint: "Briefly describe your research background...",
              icon: Icons.description_outlined,
            ),

            inputField(
              label: "Looking For",
              controller: lookingForController,
              maxLines: 2,
              hint: "Supervisor, collaborators, research friends...",
              icon: Icons.search,
            ),

            helperBox(),

            sectionTitle(
              "Research Matching Data",
              "These fields will power compatibility score and future swipe matching.",
            ),

            inputField(
              label: "Research Interests",
              controller: interestsController,
              maxLines: 3,
              hint: "Medical Imaging, Deep Learning, NLP",
              icon: Icons.psychology_outlined,
            ),

            inputField(
              label: "Skills",
              controller: skillsController,
              maxLines: 3,
              hint: "Flutter, Python, PyTorch, Research Writing",
              icon: Icons.code,
            ),

            sectionTitle(
              "Academic Work",
              "Add publications and projects to strengthen your profile.",
            ),

            inputField(
              label: "Publications",
              controller: publicationsController,
              maxLines: 4,
              hint: "Paper title 1, Paper title 2",
              icon: Icons.article_outlined,
            ),

            inputField(
              label: "Projects",
              controller: projectsController,
              maxLines: 4,
              hint: "Research AI Assistant, Brain Tumor Segmentation",
              icon: Icons.work_outline,
            ),

            sectionTitle(
              "Academic Links",
              "Add links that help other researchers evaluate your background.",
            ),

            inputField(
              label: "Google Scholar",
              controller: googleScholarController,
              icon: Icons.school,
            ),

            inputField(
              label: "GitHub",
              controller: githubController,
              icon: Icons.link,
            ),

            inputField(
              label: "LinkedIn",
              controller: linkedInController,
              icon: Icons.business_center_outlined,
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text("Save Research Profile"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
