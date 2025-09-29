import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/stores/app_user_profile_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class AppUserProfileFirebaseRepository extends AppUserProfileStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();
  static final FirebaseAuth _firebaseAuth = GetIt.instance<FirebaseAuth>();

  final CollectionReference<Map<String, dynamic>?> _authUserRefCollection = _firebaseFirestore.collection('users').withConverter<Map<String, dynamic>?>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (map, _) => map as Map<String, dynamic>,
      );
  final CollectionReference<AppUserProfile> _userProfileCollection = _firebaseFirestore.collection('userProfiles').withConverter<AppUserProfile>(
        fromFirestore: (snapshot, _) => AppUserProfile.fromMap(snapshot.data() ?? {}),
        toFirestore: (map, _) => map.toMap(),
      );

  @override
  Future<AppUserProfile> getUserProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot<AppUserProfile> snapshot = await _userProfileCollection.doc(user.uid).get();
      if (snapshot.data() != null) {
        AppUserProfile profile = snapshot.data()!;
        profile = profile.copyWith(email: user.email, createdAt: Timestamp.fromDate(user.metadata.creationTime ?? DateTime.now()));
        return profile;
      } else {
        Map<String, dynamic> userMap = AuthProviderUserDetails.firebaseMetadataToMap(user);
        AuthProviderUserDetails userDetails = AuthProviderUserDetails.fromMap(userMap);
        AppUserProfile userProfile = AppUserProfile.fromAuthProviderUserDetails(userDetails);
        updateUserProfile(userProfile: userProfile);
        return userProfile;
      }
    } else {
      throw 'Unauthenticated';
    }
  }

  @override
  Future<void> updateUserProfile({required AppUserProfile userProfile}) async {
    if (userProfile.uid != null && userProfile.uid!.isNotEmpty) {
      await _userProfileCollection.doc(userProfile.uid).set(userProfile, SetOptions(merge: true));
    }
  }

  @override
  Future<void> deleteUserProfile(AppUserProfile userProfile) async {
    if (userProfile.uid != null && userProfile.uid != '') {
      _authUserRefCollection.doc(userProfile.uid).delete();
      _userProfileCollection.doc(userProfile.uid).delete();
    }
  }

  @override
  Future<List<AppUserProfile>> loadAllProfiles() async {
    QuerySnapshot<AppUserProfile> snapshot = await _userProfileCollection.get();
    List<AppUserProfile> profiles = [];

    for (QueryDocumentSnapshot<AppUserProfile> doc in snapshot.docs) {
      profiles.add(doc.data());
    }

    profiles.sort((a, b) => (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

    return profiles;
  }

  @override
  Future<List<AppUserProfile>> getAdminProfiles() async {
    List<String> adminRoles = ['admin', 'superAdmin'];
    QuerySnapshot<AppUserProfile> snapshot = await _userProfileCollection.where('role', whereIn: adminRoles).get();
    List<AppUserProfile> profiles = [];

    for (QueryDocumentSnapshot<AppUserProfile> doc in snapshot.docs) {
      profiles.add(doc.data());
    }

    profiles.sort((a, b) => (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

    return profiles;
  }

  @override
  Future<num?> getUserProfileCount() async {
    AggregateQuerySnapshot query = await _userProfileCollection.count().get();
    return query.count;
  }
}
