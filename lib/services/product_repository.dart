import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/dummy_products.dart';
import '../models/product_model.dart';

class ProductRepository {
  ProductRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _products.orderBy('name').get();
      if (snapshot.docs.isEmpty) {
        return dummyProducts;
      }
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    } catch (_) {
      return dummyProducts;
    }
  }

  Future<void> seedDefaultProductsIfEmpty() async {
    final snapshot = await _products.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final product in dummyProducts) {
      batch.set(_products.doc(product.id), product.toMap());
    }
    await batch.commit();
  }
}
