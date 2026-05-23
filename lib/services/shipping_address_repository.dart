import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/address_model.dart';
import 'firebase_auth_service.dart';

class ShippingAddressRepository {
  ShippingAddressRepository({
    FirebaseFirestore? firestore,
    FirebaseAuthService? authService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? FirebaseAuthService();

  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;

  Future<CollectionReference<Map<String, dynamic>>> _addressesRef() async {
    final user = await _authService.ensureUser();
    return _firestore.collection('users').doc(user.uid).collection('addresses');
  }

  Future<List<AddressItem>> fetchAddresses() async {
    final snapshot = await (await _addressesRef()).orderBy('createdAt').get();
    return snapshot.docs
        .map((doc) => AddressItem.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<AddressItem?> fetchDefaultAddress() async {
    final addresses = await fetchAddresses();
    if (addresses.isEmpty) {
      return null;
    }
    return addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => addresses.first,
    );
  }

  Future<AddressItem> addAddress(AddressItem item) async {
    final ref = (await _addressesRef()).doc();
    final shouldBeDefault = item.isDefault || await _isFirstAddress();
    if (shouldBeDefault) {
      await _clearDefaultAddresses();
    }
    final savedItem = item.copyWith(id: ref.id, isDefault: shouldBeDefault);
    await ref.set({
      ...savedItem.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return savedItem;
  }

  Future<AddressItem> updateAddress(AddressItem item) async {
    if (item.id.isEmpty) {
      return addAddress(item);
    }
    if (item.isDefault) {
      await _clearDefaultAddresses(exceptId: item.id);
    }
    await (await _addressesRef()).doc(item.id).set({
      ...item.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return item;
  }

  Future<void> removeAddress(AddressItem item) async {
    if (item.id.isEmpty) {
      return;
    }
    final addressesRef = await _addressesRef();
    await addressesRef.doc(item.id).delete();
    if (!item.isDefault) {
      return;
    }

    final snapshot = await addressesRef.orderBy('createdAt').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.set({
        'isDefault': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<bool> _isFirstAddress() async {
    final snapshot = await (await _addressesRef()).limit(1).get();
    return snapshot.docs.isEmpty;
  }

  Future<void> _clearDefaultAddresses({String? exceptId}) async {
    final snapshot = await (await _addressesRef())
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
