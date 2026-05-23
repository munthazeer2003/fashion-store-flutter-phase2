import '../core/mvvm/base_view_model.dart';
import '../services/cart_repository.dart';

class CartViewModel extends BaseViewModel {
  CartViewModel({CartRepository? cartRepository})
    : _cartRepository = cartRepository ?? CartRepository();

  final CartRepository _cartRepository;
  bool _loaded = false;
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  Future<void> loadCart() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      final firebaseItems = await _cartRepository.fetchCart();
      _items
        ..clear()
        ..addAll(firebaseItems);
      clearError();
    } catch (_) {
      setError('Could not load your Firebase cart. Showing local items.');
    } finally {
      setBusy(false);
    }
  }

  double get total {
    double total = 0;
    for (final item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> removeAt(int index) async {
    final item = _items.removeAt(index);
    notifyListeners();
    try {
      await _cartRepository.removeItem(item.id);
    } catch (_) {
      setError('Could not remove item from Firebase.');
    }
  }

  Future<void> increment(int index) async {
    final item = _items[index];
    item.quantity += 1;
    notifyListeners();
    try {
      await _cartRepository.updateQuantity(item.id, item.quantity);
    } catch (_) {
      setError('Could not update cart quantity.');
    }
  }

  Future<void> decrement(int index) async {
    if (_items[index].quantity == 1) {
      return;
    }
    final item = _items[index];
    item.quantity -= 1;
    notifyListeners();
    try {
      await _cartRepository.updateQuantity(item.id, item.quantity);
    } catch (_) {
      setError('Could not update cart quantity.');
    }
  }
}

class CartItem {
  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;

  factory CartItem.fromMap(String id, Map<String, dynamic> data) {
    return CartItem(
      id: id,
      name: data['name'] as String? ?? 'Product',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      image: data['image'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}
