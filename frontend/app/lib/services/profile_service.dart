import '../models/profile_model.dart';

class ProfileService {
  static ProfileModel? currentProfile;

  static Future<void> loadProfile() async {
    currentProfile ??= ProfileModel(
      name: "Tawhid Ahmed Komol",
      university: "University of Electro-Communications",
      department: "Computer Science",
      bio:
          "AI researcher focused on medical imaging, deep learning, and academic collaboration systems.",
      interests: [
        "Deep Learning",
        "Medical Imaging",
        "Brain Tumor Segmentation",
      ],
      skills: ["Flutter", "Python", "PyTorch", "Research Writing"],
      email: "example@email.com",
      github: "github.com/username",
      linkedin: "linkedin.com/in/username",
    );
  }

  static Future<void> saveProfile(ProfileModel profile) async {
    currentProfile = profile;
  }
}
