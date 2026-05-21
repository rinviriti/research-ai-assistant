import 'package:flutter/foundation.dart';

import '../models/research_profile_model.dart';
import 'auth_service.dart';
import 'local_storage_service.dart';

class ResearchProfileService {
  static ResearchProfileModel? currentProfile;

  static const String storageKey = "rh_research_profile";

  static Future<void> loadProfile() async {
    try {
      final data = await LocalStorageService.getJson(storageKey);

      if (data == null) {
        currentProfile = null;
        return;
      }

      currentProfile = ResearchProfileModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (e) {
      debugPrint("Failed to load research profile: $e");
      currentProfile = null;
      await LocalStorageService.remove(storageKey);
    }
  }

  static Future<void> createDefaultProfile() async {
    final now = DateTime.now();

    final profile = ResearchProfileModel(
      userId: AuthService.currentUserEmail ?? "local_user",
      name: AuthService.currentUser ?? "Researcher",
      email: AuthService.currentUserEmail ?? "researcher@email.com",
      university: "",
      department: "",
      bio: "",
      location: "",
      lookingFor: "",
      researchInterests: [],
      skills: [],
      publications: [],
      projects: [],
      googleScholar: "",
      github: "",
      linkedIn: "",
      orcid: "",
      website: "",
      profileImagePath: "",
      cvPath: "",
      isVerified: false,
      createdAt: now,
      updatedAt: now,
    );

    await saveProfile(profile);
  }

  static Future<void> ensureProfile() async {
    await loadProfile();

    if (currentProfile == null) {
      await createDefaultProfile();
    }
  }

  static Future<void> saveProfile(ResearchProfileModel profile) async {
    currentProfile = profile.copyWith(updatedAt: DateTime.now());

    await LocalStorageService.saveJson(
      key: storageKey,
      data: currentProfile!.toJson(),
    );
  }

  static Future<void> updateProfileImage(String imagePath) async {
    await ensureProfile();

    await saveProfile(currentProfile!.copyWith(profileImagePath: imagePath));
  }

  static Future<void> updateCvPath(String cvPath) async {
    await ensureProfile();

    await saveProfile(currentProfile!.copyWith(cvPath: cvPath));
  }

  static Future<void> deleteProfile() async {
    currentProfile = null;
    await LocalStorageService.remove(storageKey);
  }

  static bool hasProfile() {
    return currentProfile != null;
  }
}
