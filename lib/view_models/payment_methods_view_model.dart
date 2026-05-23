import '../core/mvvm/base_view_model.dart';
import '../models/payment_method_model.dart';
import '../services/payment_method_repository.dart';

class PaymentMethodsViewModel extends BaseViewModel {
  PaymentMethodsViewModel({PaymentMethodRepository? paymentMethodRepository})
    : _paymentMethodRepository =
          paymentMethodRepository ?? PaymentMethodRepository();

  final PaymentMethodRepository _paymentMethodRepository;
  final List<PaymentMethodItem> _methods = [];
  bool _loaded = false;

  List<PaymentMethodItem> get methods => List.unmodifiable(_methods);
  bool get hasOnlinePayment => _methods.any((method) => method.isOnline);

  Future<void> loadPaymentMethods({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      final firebaseMethods = await _paymentMethodRepository
          .fetchPaymentMethods();
      _methods
        ..clear()
        ..addAll(firebaseMethods);
      _sortDefaultFirst();
      clearError();
    } catch (_) {
      setError('Could not load your Firebase payment methods.');
    } finally {
      setBusy(false);
    }
  }

  Future<bool> addPaymentMethod(PaymentMethodItem item) async {
    if (!_isValid(item)) {
      return false;
    }
    setBusy(true);
    try {
      final savedItem = await _paymentMethodRepository.addPaymentMethod(item);
      _methods.add(savedItem);
      _sortDefaultFirst();
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not save your payment method in Firebase.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> addOnlinePayment() {
    if (hasOnlinePayment) {
      final index = _methods.indexWhere((method) => method.isOnline);
      return setDefault(index);
    }
    return addPaymentMethod(PaymentMethodItem.onlinePayment());
  }

  Future<bool> updatePaymentMethod(int index, PaymentMethodItem item) async {
    if (!_isValid(item)) {
      return false;
    }
    setBusy(true);
    try {
      final savedItem = await _paymentMethodRepository.updatePaymentMethod(
        item,
      );
      _methods[index] = savedItem;
      _sortDefaultFirst();
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not update your Firebase payment method.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> setDefault(int index) async {
    final item = _methods[index];
    setBusy(true);
    try {
      await _paymentMethodRepository.setDefaultPaymentMethod(item);
      for (var i = 0; i < _methods.length; i++) {
        _methods[i] = _methods[i].copyWith(isDefault: i == index);
      }
      _sortDefaultFirst();
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not select this Firebase payment method.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> removePaymentMethod(int index) async {
    final item = _methods[index];
    setBusy(true);
    try {
      await _paymentMethodRepository.removePaymentMethod(item);
      _methods.removeAt(index);
      if (item.isDefault && _methods.isNotEmpty) {
        _methods[0] = _methods[0].copyWith(isDefault: true);
      }
      _sortDefaultFirst();
      clearError();
      notifyListeners();
      return true;
    } catch (_) {
      setError('Could not delete your Firebase payment method.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  bool _isValid(PaymentMethodItem item) {
    if (item.brand.trim().isEmpty || item.holderName.trim().isEmpty) {
      setError('Please enter valid payment details.');
      return false;
    }
    if (!item.isCash && !item.isOnline && item.last4.trim().length < 3) {
      setError('Please enter valid payment details.');
      return false;
    }
    return true;
  }

  void _sortDefaultFirst() {
    _methods.sort((a, b) {
      if (a.isDefault == b.isDefault) {
        return a.brand.compareTo(b.brand);
      }
      return a.isDefault ? -1 : 1;
    });
  }
}
