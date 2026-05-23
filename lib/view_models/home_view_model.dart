import '../data/dummy_products.dart';
import '../models/product_model.dart';
import '../models/user_profile.dart';
import '../services/product_repository.dart';
import '../services/user_profile_repository.dart';
import 'product_catalog_view_model.dart';

class HomeViewModel extends ProductCatalogViewModel {
  HomeViewModel({
    ProductRepository? productRepository,
    UserProfileRepository? userProfileRepository,
  }) : _productRepository = productRepository ?? ProductRepository(),
       _userProfileRepository =
           userProfileRepository ?? UserProfileRepository();

  final ProductRepository _productRepository;
  final UserProfileRepository _userProfileRepository;
  bool _loaded = false;
  List<Product> _products = dummyProducts;
  UserProfile _profile = UserProfile.empty();

  List<Product> get popularProducts => _products.take(10).toList();
  List<Product> get newArrivals => _products;
  String get userName => _profile.name;

  Future<void> loadProducts() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      try {
        await _productRepository.seedDefaultProductsIfEmpty();
      } catch (_) {
        // Product reads still work with local fallback if seeding is blocked.
      }
      _products = await _productRepository.fetchProducts();
      _profile = await _userProfileRepository.currentProfile();
      clearError();
    } catch (_) {
      _products = dummyProducts;
      setError('Could not load Firebase data. Showing local products.');
    } finally {
      setBusy(false);
    }
  }
}
