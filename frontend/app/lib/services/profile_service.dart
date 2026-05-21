import '../models/research_profile_model.dart';
import 'auth_service.dart';
import 'local_storage_service.dart';

class ProfileService {
  static ResearchProfileModel? currentProfile;

  static const String storageKey = "rh_research_profile";

  static Future<void> loadProfile() async {
    final data = await LocalStorageService.getJson(storageKey);

    if (data != null) {
      currentProfile = ResearchProfileModel.fromJson(
        Map<String, dynamic>.from(data),
      );

      return;
    }

    currentProfile = ResearchProfileModel(
      userId: "rh_user_001",

      name: AuthService.currentUser ?? "Researcher",

      email: AuthService.currentUserEmail ?? "researcher@email.com",

      university: "University of Electro-Communications",

      department: "Computer Science",

      bio:
          "AI researcher focused on medical imaging, deep learning, and academic collaboration systems.",

      location: "Tokyo, Japan",

      lookingFor:
          "Research collaborations, publications, and PhD opportunities.",

      researchInterests: [
        "Deep Learning",
        "Medical Imaging",
        "Brain Tumor Segmentation",
      ],

      skills: ["Flutter", "Python", "PyTorch", "Research Writing"],

      publications: ["Swin-UNet++ for Brain Tumor Segmentation"],

      projects: ["RH+ Research Hub Platform"],

      googleScholar: "",

      github: "https://github.com/",

      linkedIn: "https://linkedin.com/",

      orcid: "",

      website: "",

      profileImagePath: "",

      cvPath: "",

      isVerified: false,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),
    );

    await saveProfile(currentProfile!);
  }

  static Future<void> saveProfile(ResearchProfileModel profile) async {
    currentProfile = profile.copyWith(updatedAt: DateTime.now());

    await LocalStorageService.saveJson(
      key: storageKey,
      data: currentProfile!.toJson(),
    );
  }

  static Future<void> clearProfile() async {
    currentProfile = null;

    await LocalStorageService.remove(storageKey);
  }
}
