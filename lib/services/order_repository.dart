import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import '../view_models/cart_view_model.dart';
import 'cart_repository.dart';
import 'firebase_auth_service.dart';

class OrderRepository {
  OrderRepository({
    FirebaseFirestore? firestore,
    FirebaseAuthService? authService,
    CartRepository? cartRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? FirebaseAuthService(),
       _cartRepository = cartRepository ?? CartRepository();

  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;
  final CartRepository _cartRepository;

  Future<String> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    required String shippingTitle,
    required String shippingSubtitle,
    required String paymentTitle,
    required String paymentSubtitle,
  }) async {
    final user = await _authService.ensureUser();
    final userOrderRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc();
    final orderId = userOrderRef.id;
    final orderData = {
      'id': orderId,
      'userId': user.uid,
      'status': 'active',
      'items': items.map((item) => item.toMap()).toList(),
      'itemsCount': items.fold<int>(
        0,
        (runningTotal, item) => runningTotal + item.quantity,
      ),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'shippingTitle': shippingTitle,
      'shippingSubtitle': shippingSubtitle,
      'paymentTitle': paymentTitle,
      'paymentSubtitle': paymentSubtitle,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final batch = _firestore.batch();
    batch.set(userOrderRef, orderData);
    batch.set(_firestore.collection('orders').doc(orderId), orderData);
    await batch.commit();
    await _cartRepository.clearCart();
    return orderId;
  }

  Future<List<OrderItem>> fetchUserOrders() async {
    final user = await _authService.ensureUser();
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final items = data['items'] as List<dynamic>? ?? [];
      final firstItem = items.isNotEmpty && items.first is Map
          ? Map<String, dynamic>.from(items.first as Map)
          : <String, dynamic>{};
      return OrderItem(
        id: '#${doc.id.substring(0, doc.id.length < 6 ? doc.id.length : 6)}',
        itemsCount: (data['itemsCount'] as num?)?.toInt() ?? items.length,
        total: (data['total'] as num?)?.toDouble() ?? 0,
        image:
            firstItem['image'] as String? ??
            'assets/images/products/shoes/shoe_1.jpg',
        status: _statusFromString(data['status'] as String?),
      );
    }).toList();
  }

  OrderStatus _statusFromString(String? value) {
    return switch (value) {
      'completed' => OrderStatus.completed,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.active,
    };
  }
}
