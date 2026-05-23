import '../core/mvvm/base_view_model.dart';
import '../models/address_model.dart';
import '../services/shipping_address_repository.dart';

class ShippingAddressViewModel extends BaseViewModel {
  ShippingAddressViewModel({
    ShippingAddressRepository? shippingAddressRepository,
  }) : _shippingAddressRepository =
           shippingAddressRepository ?? ShippingAddressRepository();

  final ShippingAddressRepository _shippingAddressRepository;
  final List<AddressItem> _addresses = [];
  bool _loaded = false;

  List<AddressItem> get addresses => List.unmodifiable(_addresses);

  Future<void> loadAddresses({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      final firebaseAddresses = await _shippingAddressRepository
          .fetchAddresses();
      _addresses
        ..clear()
        ..addAll(firebaseAddresses);
      clearError();
    } catch (_) {
      setError('Could not load your Firebase addresses.');
    } finally {
      setBusy(false);
    }
  }

  Future<bool> addAddress(AddressItem item) async {
    if (!_isValid(item)) {
      return false;
    }
    setBusy(true);
    try {
      final savedItem = await _shippingAddressRepository.addAddress(item);
      _addresses.add(savedItem);
      _sortDefaultFirst();
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not save your address in Firebase.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> updateAddress(int index, AddressItem item) async {
    if (!_isValid(item)) {
      return false;
    }
    setBusy(true);
    try {
      final savedItem = await _shippingAddressRepository.updateAddress(item);
      _addresses[index] = savedItem;
      _sortDefaultFirst();
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not update your Firebase address.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> removeAddress(int index) async {
    final item = _addresses[index];
    setBusy(true);
    try {
      await _shippingAddressRepository.removeAddress(item);
      _addresses.removeAt(index);
      if (item.isDefault && _addresses.isNotEmpty) {
        _addresses[0] = _addresses[0].copyWith(isDefault: true);
      }
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not delete your Firebase address.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  bool _isValid(AddressItem item) {
    if (item.addressLine1.trim().isEmpty || item.addressLine2.trim().isEmpty) {
      setError('Please enter a complete address.');
      return false;
    }
    return true;
  }

  void _sortDefaultFirst() {
    _addresses.sort((a, b) {
      if (a.isDefault == b.isDefault) {
        return a.title.compareTo(b.title);
      }
      return a.isDefault ? -1 : 1;
    });
  }
}
