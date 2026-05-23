import '../core/mvvm/base_view_model.dart';
import '../models/product_model.dart';
import '../services/cart_repository.dart';
import '../services/wishlist_repository.dart';

class ProductDetailViewModel extends BaseViewModel {
  ProductDetailViewModel({
    CartRepository? cartRepository,
    WishlistRepository? wishlistRepository,
  }) : _cartRepository = cartRepository ?? CartRepository(),
       _wishlistRepository = wishlistRepository ?? WishlistRepository();

  final CartRepository _cartRepository;
  final WishlistRepository _wishlistRepository;
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  int _selectedSizeIndex = 3;
  bool _isFavorite = false;

  int get selectedSizeIndex => _selectedSizeIndex;
  bool get isFavorite => _isFavorite;

  void selectSize(int index) {
    if (_selectedSizeIndex == index) {
      return;
    }
    _selectedSizeIndex = index;
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    _isFavorite = !_isFavorite;
    notifyListeners();
    try {
      if (_isFavorite) {
        await _wishlistRepository.saveProduct(product);
      } else {
        await _wishlistRepository.removeItem(product.id);
      }
      clearError();
    } catch (_) {
      setError('Could not update Firebase wishlist.');
    }
  }

  Future<bool> addToCart(Product product) async {
    setBusy(true);
    try {
      await _cartRepository.addProduct(product);
      clearError();
      return true;
    } catch (_) {
      setError('Could not add item to Firebase cart.');
      return false;
    } finally {
      setBusy(false);
    }
  }
}
