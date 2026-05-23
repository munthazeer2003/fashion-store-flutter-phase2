import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../view_models/wishlist_view_model.dart';
import 'firebase_auth_service.dart';

class WishlistRepository {
  WishlistRepository({
    FirebaseFirestore? firestore,
    FirebaseAuthService? authService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? FirebaseAuthService();

  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;

  Future<CollectionReference<Map<String, dynamic>>> _wishlistRef() async {
    final user = await _authService.ensureUser();
    return _firestore.collection('users').doc(user.uid).collection('wishlist');
  }

  Future<List<WishlistItem>> fetchWishlist() async {
    final snapshot = await (await _wishlistRef()).orderBy('addedAt').get();
    return snapshot.docs
        .map((doc) => WishlistItem.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> saveProduct(Product product) async {
    await (await _wishlistRef()).doc(product.id).set({
      ...product.toMap(),
      'addedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeItem(String id) async {
    await (await _wishlistRef()).doc(id).delete();
  }
}
