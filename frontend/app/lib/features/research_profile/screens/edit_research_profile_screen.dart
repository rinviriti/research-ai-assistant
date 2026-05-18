import 'package:flutter/material.dart';

import '../../../constants/research_options.dart';
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

  final publicationsController = TextEditingController();
  final projectsController = TextEditingController();

  final googleScholarController = TextEditingController();
  final githubController = TextEditingController();
  final linkedInController = TextEditingController();

  List<String> selectedInterests = [];
  List<String> selectedSkills = [];

  @override
  void initState() {
    super.initState();
    loadCurrentProfile();
  }

  Future<void> loadCurrentProfile() async {
    await ResearchProfileService.loadProfile();

    final profile = ResearchProfileService.currentProfile;

    if (profile == null) {
      setState(() {});
      return;
    }

    nameController.text = profile.name;
    emailController.text = profile.email;
    universityController.text = profile.university;
    departmentController.text = profile.department;
    bioController.text = profile.bio;
    locationController.text = profile.location;
    lookingForController.text = profile.lookingFor;

    selectedInterests = List<String>.from(profile.researchInterests);
    selectedSkills = List<String>.from(profile.skills);

    publicationsController.text = profile.publications.join(", ");
    projectsController.text = profile.projects.join(", ");

    googleScholarController.text = profile.googleScholar;
    githubController.text = profile.github;
    linkedInController.text = profile.linkedIn;

    if (mounted) setState(() {});
  }

  List<String> splitList(String text) {
    return text
        .split(",")
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  void toggleSkill(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
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

    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one research interest."),
        ),
      );
      return;
    }

    if (selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one skill.")),
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
      researchInterests: selectedInterests,
      skills: selectedSkills,
      publications: splitList(publicationsController.text),
      projects: splitList(projectsController.text),
      googleScholar: googleScholarController.text.trim(),
      github: githubController.text.trim(),
      linkedIn: linkedInController.text.trim(),
    );

    await ResearchProfileService.saveProfile(updatedProfile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Research profile saved successfully 🚀")),
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
              "Select research interests and skills from the options below. These selections will be used for collaborator matching, supervisor discovery, and research recommendation scoring.",
              style: TextStyle(color: Colors.white70, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectableOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 10),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        showCheckmark: true,
        checkmarkColor: Colors.black,
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: primary,
        side: BorderSide(color: selected ? primary : Colors.white12),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget optionSelector({
    required String title,
    required String subtitle,
    required List<String> options,
    required List<String> selectedItems,
    required void Function(String value) onToggle,
    required IconData icon,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
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
              Icon(icon, color: primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: primary.withOpacity(0.35)),
                ),
                child: Text(
                  "${selectedItems.length} selected",
                  style: TextStyle(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            children: options.map((option) {
              return selectableOption(
                label: option,
                selected: selectedItems.contains(option),
                onTap: () => onToggle(option),
              );
            }).toList(),
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
    final hasExistingProfile = ResearchProfileService.currentProfile != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          hasExistingProfile
              ? "Edit Research Profile"
              : "Create Research Profile",
        ),
      ),
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
                  Text(
                    hasExistingProfile
                        ? "Update Your Academic Identity"
                        : "Create Your Academic Identity",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your profile will power researcher matching, academic networking, and future AI recommendation features.",
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
              "Choose options instead of typing everything manually.",
            ),

            optionSelector(
              title: "Research Interests",
              subtitle:
                  "Select topics that best describe your academic interests.",
              options: ResearchOptions.interests,
              selectedItems: selectedInterests,
              onToggle: toggleInterest,
              icon: Icons.psychology_outlined,
            ),

            optionSelector(
              title: "Skills",
              subtitle: "Select your technical and research-related strengths.",
              options: ResearchOptions.skills,
              selectedItems: selectedSkills,
              onToggle: toggleSkill,
              icon: Icons.code,
            ),

            sectionTitle(
              "Academic Work",
              "Use commas to separate publications and projects.",
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
              "Add links that help others evaluate your research background.",
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
                label: Text(
                  hasExistingProfile
                      ? "Update Research Profile"
                      : "Create Research Profile",
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
