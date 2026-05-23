import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/payment_method_model.dart';
import 'firebase_auth_service.dart';

class PaymentMethodRepository {
  PaymentMethodRepository({
    FirebaseFirestore? firestore,
    FirebaseAuthService? authService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? FirebaseAuthService();

  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;

  Future<CollectionReference<Map<String, dynamic>>> _paymentMethodsRef() async {
    final user = await _authService.ensureUser();
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('paymentMethods');
  }

  Future<List<PaymentMethodItem>> fetchPaymentMethods() async {
    final ref = await _paymentMethodsRef();
    final snapshot = await ref.orderBy('createdAt').get();
    if (snapshot.docs.isEmpty) {
      final cashMethod = await addPaymentMethod(
        PaymentMethodItem.cashOnDelivery(),
      );
      final onlineMethod = await addPaymentMethod(
        PaymentMethodItem.onlinePayment(),
      );
      return [cashMethod, onlineMethod];
    }
    final methods = snapshot.docs
        .map((doc) => PaymentMethodItem.fromMap(doc.id, doc.data()))
        .toList();
    if (!methods.any((method) => method.isOnline)) {
      methods.add(await addPaymentMethod(PaymentMethodItem.onlinePayment()));
    }
    return methods;
  }

  Future<PaymentMethodItem> fetchDefaultPaymentMethod() async {
    final methods = await fetchPaymentMethods();
    return methods.firstWhere(
      (method) => method.isDefault,
      orElse: () => methods.first,
    );
  }

  Future<PaymentMethodItem> addPaymentMethod(PaymentMethodItem item) async {
    final ref = (await _paymentMethodsRef()).doc();
    final shouldBeDefault = item.isDefault || await _isFirstPaymentMethod();
    if (shouldBeDefault) {
      await _clearDefaultPaymentMethods();
    }
    final savedItem = item.copyWith(id: ref.id, isDefault: shouldBeDefault);
    await ref.set({
      ...savedItem.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return savedItem;
  }

  Future<PaymentMethodItem> updatePaymentMethod(PaymentMethodItem item) async {
    if (item.id.isEmpty) {
      return addPaymentMethod(item);
    }
    if (item.isDefault) {
      await _clearDefaultPaymentMethods(exceptId: item.id);
    }
    await (await _paymentMethodsRef()).doc(item.id).set({
      ...item.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return item;
  }

  Future<void> setDefaultPaymentMethod(PaymentMethodItem item) async {
    if (item.id.isEmpty) {
      return;
    }
    await _clearDefaultPaymentMethods(exceptId: item.id);
    await (await _paymentMethodsRef()).doc(item.id).set({
      'isDefault': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removePaymentMethod(PaymentMethodItem item) async {
    if (item.id.isEmpty) {
      return;
    }
    final ref = await _paymentMethodsRef();
    await ref.doc(item.id).delete();
    if (!item.isDefault) {
      return;
    }

    final snapshot = await ref.orderBy('createdAt').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.set({
        'isDefault': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<bool> _isFirstPaymentMethod() async {
    final snapshot = await (await _paymentMethodsRef()).limit(1).get();
    return snapshot.docs.isEmpty;
  }

  Future<void> _clearDefaultPaymentMethods({String? exceptId}) async {
    final snapshot = await (await _paymentMethodsRef())
        .where('isDefault', isEqualTo: true)
        .get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      if (doc.id == exceptId) {
        continue;
      }
      batch.set(doc.reference, {
        'isDefault': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    await batch.commit();
  }
}
