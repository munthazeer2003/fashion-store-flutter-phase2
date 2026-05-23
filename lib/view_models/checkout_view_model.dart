import '../core/constants.dart';
import '../core/mvvm/base_view_model.dart';
import '../models/address_model.dart';
import '../models/payment_method_model.dart';
import '../services/cart_repository.dart';
import '../services/order_repository.dart';
import '../services/payment_method_repository.dart';
import '../services/shipping_address_repository.dart';
import 'cart_view_model.dart';

class CheckoutViewModel extends BaseViewModel {
  CheckoutViewModel({
    CartRepository? cartRepository,
    OrderRepository? orderRepository,
    ShippingAddressRepository? shippingAddressRepository,
    PaymentMethodRepository? paymentMethodRepository,
  }) : _cartRepository = cartRepository ?? CartRepository(),
       _orderRepository = orderRepository ?? OrderRepository(),
       _shippingAddressRepository =
           shippingAddressRepository ?? ShippingAddressRepository(),
       _paymentMethodRepository =
           paymentMethodRepository ?? PaymentMethodRepository();

  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  final ShippingAddressRepository _shippingAddressRepository;
  final PaymentMethodRepository _paymentMethodRepository;
  bool _loaded = false;
  List<CartItem> _items = [];
  AddressItem? _shippingAddress;
  PaymentMethodItem? _paymentMethod;

  String get shippingTitle => _shippingAddress?.title ?? 'Add Address';
  String get shippingSubtitle => _shippingAddress == null
      ? 'Choose a saved shipping address'
      : '${_shippingAddress!.addressLine1}\n${_shippingAddress!.addressLine2}';

  String get paymentTitle => _paymentMethod?.title ?? 'Add Payment Method';
  String get paymentSubtitle =>
      _paymentMethod?.subtitle ?? 'Choose how you want to pay';

  List<CartItem> get items => List.unmodifiable(_items);
  double get subtotalValue =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  double get shippingValue => subtotalValue == 0 ? 0 : 350;
  double get taxValue => subtotalValue * 0.05;
  double get totalValue => subtotalValue + shippingValue + taxValue;

  String get subtotal => _format(subtotalValue);
  String get shipping => _format(shippingValue);
  String get tax => _format(taxValue);
  String get total => _format(totalValue);

  Future<void> loadCheckout({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      _items = await _cartRepository.fetchCart();
      _shippingAddress = await _shippingAddressRepository.fetchDefaultAddress();
      _paymentMethod = await _paymentMethodRepository
          .fetchDefaultPaymentMethod();
      clearError();
    } catch (_) {
      setError('Could not load Firebase checkout items.');
    } finally {
      setBusy(false);
    }
  }

  Future<String?> placeOrder() async {
    if (_items.isEmpty) {
      setError('Your cart is empty.');
      return null;
    }
    if (_shippingAddress == null) {
      setError('Please add a shipping address before checkout.');
      return null;
    }
    if (_paymentMethod == null) {
      setError('Please add a payment method before checkout.');
      return null;
    }
    setBusy(true);
    try {
      final orderId = await _orderRepository.placeOrder(
        items: _items,
        subtotal: subtotalValue,
        shipping: shippingValue,
        tax: taxValue,
        total: totalValue,
        shippingTitle: shippingTitle,
        shippingSubtitle: shippingSubtitle,
        paymentTitle: paymentTitle,
        paymentSubtitle: paymentSubtitle,
      );
      _items = [];
      clearError();
      notifyListeners();
      return orderId;
    } catch (_) {
      setError('Could not place order in Firebase.');
      return null;
    } finally {
      setBusy(false);
    }
  }

  String _format(double value) {
    return '${AppConstants.currency} ${value.toStringAsFixed(2)}';
  }
}
