import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../constants/research_options.dart';
import '../../../models/research_profile_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/media_service.dart';
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
  final orcidController = TextEditingController();
  final websiteController = TextEditingController();

  List<String> selectedInterests = [];
  List<String> selectedSkills = [];

  String profileImagePath = "";
  String cvPath = "";

  ResearchProfileModel? existingProfile;

  @override
  void initState() {
    super.initState();
    loadCurrentProfile();
  }

  Future<void> loadCurrentProfile() async {
    await ResearchProfileService.loadProfile();

    final profile = ResearchProfileService.currentProfile;
    existingProfile = profile;

    if (profile == null) {
      nameController.text = AuthService.currentUser ?? "";
      emailController.text = AuthService.currentUserEmail ?? "";

      if (mounted) setState(() {});
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
    orcidController.text = profile.orcid;
    websiteController.text = profile.website;

    profileImagePath = profile.profileImagePath;
    cvPath = profile.cvPath;

    if (mounted) setState(() {});
  }

  Future<void> pickProfileImage() async {
    final imageBase64 = await MediaService.pickImageBase64();

    if (imageBase64 == null) return;

    setState(() {
      profileImagePath = imageBase64;
    });
  }

  Future<void> pickCvPdf() async {
    final pdfBase64 = await MediaService.pickPdfBase64();

    if (pdfBase64 == null) return;

    setState(() {
      cvPath = pdfBase64;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CV PDF uploaded successfully.")),
    );
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
      selectedInterests.contains(interest)
          ? selectedInterests.remove(interest)
          : selectedInterests.add(interest);
    });
  }

  void toggleSkill(String skill) {
    setState(() {
      selectedSkills.contains(skill)
          ? selectedSkills.remove(skill)
          : selectedSkills.add(skill);
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

    final now = DateTime.now();

    final updatedProfile = ResearchProfileModel(
      userId:
          existingProfile?.userId ??
          AuthService.currentUserEmail ??
          "local_user",
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
      orcid: orcidController.text.trim(),
      website: websiteController.text.trim(),
      profileImagePath: profileImagePath,
      cvPath: cvPath,
      isVerified: existingProfile?.isVerified ?? false,
      createdAt: existingProfile?.createdAt ?? now,
      updatedAt: now,
    );

    await ResearchProfileService.saveProfile(updatedProfile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Research profile saved successfully 🚀")),
    );

    Navigator.pop(context, true);
  }

  Widget headerCard() {
    final primary = Theme.of(context).colorScheme.primary;
    final hasExistingProfile = ResearchProfileService.currentProfile != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.20), Theme.of(context).cardColor],
        ),
      ),
      child: Column(
        children: [
          profileImageSection(),
          const SizedBox(height: 18),
          Text(
            hasExistingProfile
                ? "Update Your Academic Identity"
                : "Create Your Academic Identity",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your RH+ profile powers collaborator matching, academic networking, and future AI recommendations.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget profileImageSection() {
    final primary = Theme.of(context).colorScheme.primary;

    ImageProvider? image;

    try {
      if (profileImagePath.isNotEmpty) {
        image = MemoryImage(base64Decode(profileImagePath));
      }
    } catch (_) {
      image = null;
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: primary,
          backgroundImage: image,
          child: image == null
              ? const Icon(Icons.account_circle, color: Colors.black, size: 60)
              : null,
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: pickProfileImage,
          icon: const Icon(Icons.photo_camera_outlined),
          label: Text(
            profileImagePath.isEmpty
                ? "Upload Profile Photo"
                : "Replace Profile Photo",
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title, String subtitle, IconData icon) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
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
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, height: 1.4),
                ),
              ],
            ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "These selections improve collaborator matching, supervisor discovery, and research recommendation scoring.",
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

  Widget cvUploadCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cvPath.isEmpty ? Colors.white10 : primary.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Academic CV",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  cvPath.isEmpty
                      ? "Upload your CV as a PDF file"
                      : "CV PDF uploaded successfully",
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: pickCvPdf,
            icon: const Icon(Icons.upload_file),
            label: Text(cvPath.isEmpty ? "Upload" : "Replace"),
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
    orcidController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            headerCard(),

            sectionTitle(
              "Basic Information",
              "Add your academic identity, affiliation, and research background.",
              Icons.person_outline,
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
              Icons.psychology_outlined,
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
              "Add publications, projects, and a PDF version of your academic CV.",
              Icons.article_outlined,
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

            cvUploadCard(),

            sectionTitle(
              "Academic Links",
              "Add links that help others evaluate your research background.",
              Icons.link,
            ),

            inputField(
              label: "Google Scholar",
              controller: googleScholarController,
              icon: Icons.school,
            ),
            inputField(
              label: "GitHub",
              controller: githubController,
              icon: Icons.code,
            ),
            inputField(
              label: "LinkedIn",
              controller: linkedInController,
              icon: Icons.business_center_outlined,
            ),
            inputField(
              label: "ORCID",
              controller: orcidController,
              icon: Icons.badge_outlined,
            ),
            inputField(
              label: "Website",
              controller: websiteController,
              icon: Icons.language,
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
