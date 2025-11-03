
import 'package:dunno/models/app_user_profile.dart';

abstract class AppUserProfileStore {
  Future<AppUserProfile> getUserProfile();
  Future<void> updateUserProfile({required AppUserProfile userProfile});
  Future<void> deleteUserProfile(AppUserProfile userProfile);
  Future<List<AppUserProfile>> loadAllProfiles();
  Future<List<AppUserProfile>> getAdminProfiles();
  Future<num?> getUserProfileCount();
  Future<AppUserProfile> getProfileByUid({required String uid});
}
