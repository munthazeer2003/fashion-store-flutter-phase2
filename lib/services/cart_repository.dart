import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../view_models/cart_view_model.dart';
import 'firebase_auth_service.dart';

class CartRepository {
  CartRepository({
    FirebaseFirestore? firestore,
    FirebaseAuthService? authService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? FirebaseAuthService();

  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;

  Future<CollectionReference<Map<String, dynamic>>> _cartRef() async {
    final user = await _authService.ensureUser();
    return _firestore.collection('users').doc(user.uid).collection('cart');
  }

  Future<List<CartItem>> fetchCart() async {
    final snapshot = await (await _cartRef()).orderBy('addedAt').get();
    return snapshot.docs
        .map((doc) => CartItem.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addProduct(Product product, {int quantity = 1}) async {
    final ref = (await _cartRef()).doc(product.id);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (snapshot.exists) {
        final data = snapshot.data() ?? {};
        final currentQuantity = (data['quantity'] as num?)?.toInt() ?? 1;
        transaction.update(ref, {
          'quantity': currentQuantity + quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }
      transaction.set(ref, {
        ...product.toMap(),
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity < 1) {
      return;
    }
    await (await _cartRef()).doc(id).update({
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeItem(String id) async {
    await (await _cartRef()).doc(id).delete();
  }

  Future<void> clearCart() async {
    final snapshot = await (await _cartRef()).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
