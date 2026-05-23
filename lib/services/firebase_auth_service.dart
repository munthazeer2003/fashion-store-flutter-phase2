import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User> ensureUser() async {
    final existingUser = _auth.currentUser;
    if (existingUser != null) {
      return existingUser;
    }
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final anonymousCart = await _readAnonymousCart();
    if (_auth.currentUser?.isAnonymous == true) {
      await _auth.signOut();
    }
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      await _saveUserProfile(
        user: user,
        name: user.displayName,
        email: user.email ?? email.trim(),
      );
      await _mergeCartIntoUser(user.uid, anonymousCart);
    }
    return credential;
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final authCredential = EmailAuthProvider.credential(
      email: trimmedEmail,
      password: password,
    );
    final currentUser = _auth.currentUser;
    final UserCredential credential;

    if (currentUser != null && currentUser.isAnonymous) {
      credential = await currentUser.linkWithCredential(authCredential);
    } else {
      credential = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
    }

    final user = credential.user;
    if (user != null) {
      await user.updateDisplayName(name.trim());
      await _saveUserProfile(user: user, name: name, email: trimmedEmail);
    }
    return credential;
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> _saveUserProfile({
    required User user,
    required String? name,
    required String email,
  }) async {
    final safeName = name?.trim();
    final userDoc = _firestore.collection('users').doc(user.uid);
    final existingDoc = await userDoc.get();
    final data = {
      'name': safeName?.isNotEmpty == true ? safeName : 'Fashion User',
      'email': email.trim(),
      'phone': user.phoneNumber ?? '',
      'photoUrl': user.photoURL ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (!existingDoc.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await userDoc.set(data, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> _readAnonymousCart() async {
    final user = _auth.currentUser;
    if (user == null || !user.isAnonymous) {
      return const [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _mergeCartIntoUser(
    String userId,
    List<Map<String, dynamic>> cartItems,
  ) async {
    if (cartItems.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    final cartRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('cart');
    for (final item in cartItems) {
      final id = item['id'] as String?;
      if (id == null || id.isEmpty) {
        continue;
      }
      final data = Map<String, dynamic>.from(item)..remove('id');
      data['updatedAt'] = FieldValue.serverTimestamp();
      batch.set(cartRef.doc(id), data, SetOptions(merge: true));
    }
    await batch.commit();
  }
}
