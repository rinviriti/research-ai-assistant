import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/research_profile_model.dart';

class ResearchProfileService {
  static ResearchProfileModel? currentProfile;

  static Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("research_profile");

    if (data == null) {
      currentProfile = null;
      return;
    }

    currentProfile = ResearchProfileModel.fromJson(jsonDecode(data));
  }

  static Future<void> saveProfile(ResearchProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();

    currentProfile = profile;

    await prefs.setString("research_profile", jsonEncode(profile.toJson()));
  }

  static Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();

    currentProfile = null;
    await prefs.remove("research_profile");
  }

  static bool hasProfile() {
    return currentProfile != null;
  }
}
