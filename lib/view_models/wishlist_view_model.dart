import '../core/mvvm/base_view_model.dart';
import '../services/wishlist_repository.dart';

class WishlistViewModel extends BaseViewModel {
  WishlistViewModel({WishlistRepository? wishlistRepository})
    : _wishlistRepository = wishlistRepository ?? WishlistRepository();

  final WishlistRepository _wishlistRepository;
  bool _loaded = false;
  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  Future<void> loadWishlist() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      final firebaseItems = await _wishlistRepository.fetchWishlist();
      _items
        ..clear()
        ..addAll(firebaseItems);
      clearError();
    } catch (_) {
      setError('Could not load your Firebase wishlist.');
    } finally {
      setBusy(false);
    }
  }

  Future<void> removeAt(int index) async {
    final item = _items.removeAt(index);
    notifyListeners();
    try {
      await _wishlistRepository.removeItem(item.id);
    } catch (_) {
      setError('Could not remove wishlist item from Firebase.');
    }
  }
}

class WishlistItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;

  WishlistItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
  });

  factory WishlistItem.fromMap(String id, Map<String, dynamic> data) {
    return WishlistItem(
      id: id,
      name: data['name'] as String? ?? 'Product',
      category: data['category'] as String? ?? 'Fashion',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      image: data['image'] as String? ?? '',
    );
  }
}
