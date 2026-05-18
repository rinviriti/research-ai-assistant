import '../../../../../models/profile_model.dart';
import '../../../../../services/profile_service.dart';

class ProfileBackendRepository {
  Future<ProfileModel?> getCurrentProfile() async {
    await ProfileService.loadProfile();
    return ProfileService.currentProfile;
  }

  Future<void> saveCurrentProfile(ProfileModel profile) async {
    await ProfileService.saveProfile(profile);
  }

  Future<Map<String, dynamic>> toBackendPayload(ProfileModel profile) async {
    return profile.toJson();
  }

  Future<ProfileModel> fromBackendPayload(Map<String, dynamic> data) async {
    return ProfileModel.fromJson(data);
  }
}
