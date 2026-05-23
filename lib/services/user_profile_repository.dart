import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Future<UserProfile> currentProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      return UserProfile.empty();
    }

    final doc = await _userDoc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      final profile = UserProfile.fromMap(user.uid, doc.data()!);
      final shouldPatchEmail = profile.email.isEmpty && user.email != null;
      final shouldPatchName =
          profile.name.trim().isEmpty || profile.name == 'Fashion User';
      if (shouldPatchEmail || shouldPatchName) {
        final patched = UserProfile(
          uid: profile.uid,
          name: shouldPatchName
              ? (user.displayName?.trim().isNotEmpty == true
                    ? user.displayName!.trim()
                    : profile.name)
              : profile.name,
          email: shouldPatchEmail ? user.email! : profile.email,
          phone: profile.phone,
          photoUrl: profile.photoUrl,
        );
        await saveProfile(patched);
        return patched;
      }
      return profile;
    }

    final profile = UserProfile(
      uid: user.uid,
      name: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : 'Fashion User',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      photoUrl: user.photoURL ?? '',
    );
    await saveProfile(profile);
    return profile;
  }

  Future<void> saveProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user != null && user.uid == profile.uid) {
      if (profile.name.trim().isNotEmpty &&
          user.displayName != profile.name.trim()) {
        await user.updateDisplayName(profile.name.trim());
      }
    }
    await _userDoc(profile.uid).set({
      ...profile.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
