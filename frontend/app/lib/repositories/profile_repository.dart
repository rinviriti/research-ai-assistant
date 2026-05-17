import '../models/research_profile_model.dart';
import '../services/research_profile_service.dart';

class ProfileRepository {
  Future<ResearchProfileModel?> getProfile() async {
    await ResearchProfileService.loadProfile();
    return ResearchProfileService.currentProfile;
  }

  Future<void> saveProfile(ResearchProfileModel profile) async {
    await ResearchProfileService.saveProfile(profile);
  }
}
