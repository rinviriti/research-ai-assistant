import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/research_profile_model.dart';

class ResearchProfileService {
  static ResearchProfileModel? currentProfile;

  static ResearchProfileModel get defaultProfile {
    return ResearchProfileModel(
      name: "Rinvi Jaman Riti",
      email: "rinvi@example.com",
      university: "Daffodil International University",
      department: "Computer Science and Engineering",
      bio:
          "AI researcher interested in medical imaging, deep learning, research productivity tools, and academic collaboration.",
      location: "Dhaka, Bangladesh",
      lookingFor: "Research collaborators, supervisors, and academic friends",
      researchInterests: [
        "Medical Imaging",
        "Deep Learning",
        "Brain Tumor Segmentation",
        "Research Productivity",
      ],
      skills: [
        "Flutter",
        "Machine Learning",
        "Research Writing",
        "Data Analysis",
      ],
      publications: [
        "Swin-UNet++ for Brain Tumor Segmentation",
        "Traditional Art and Craft Item Recognition Using Deep Learning",
      ],
      projects: ["Research AI Assistant", "Brain Tumor Segmentation Research"],
      googleScholar: "",
      github: "https://github.com/rinviriti",
      linkedIn: "https://www.linkedin.com/in/rinvi-jaman",
    );
  }

  static Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("research_profile");

    if (data == null) {
      currentProfile = defaultProfile;
      await saveProfile(defaultProfile);
      return;
    }

    currentProfile = ResearchProfileModel.fromJson(jsonDecode(data));
  }

  static Future<void> saveProfile(ResearchProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();

    currentProfile = profile;

    await prefs.setString("research_profile", jsonEncode(profile.toJson()));
  }
}
