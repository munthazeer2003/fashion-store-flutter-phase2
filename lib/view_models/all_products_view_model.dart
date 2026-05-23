import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import '../models/product_model.dart';
import '../services/product_repository.dart';
import 'product_catalog_view_model.dart';

class AllProductsViewModel extends ProductCatalogViewModel {
  AllProductsViewModel({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepository();

  final ProductRepository _productRepository;
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  bool _loaded = false;
  List<Product> _products = dummyProducts;

  List<String> get filterCategories => categories;

  Future<void> loadProducts() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      _products = await _productRepository.fetchProducts();
      clearError();
    } catch (_) {
      _products = dummyProducts;
      setError('Could not load Firebase products. Showing local products.');
    } finally {
      setBusy(false);
    }
  }

  void refreshFilters() {
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final double? minPrice = double.tryParse(minController.text);
    final double? maxPrice = double.tryParse(maxController.text);
    final String selectedCategory = categories[selectedCategoryIndex];

    return _products.where((product) {
      if (selectedCategory != 'All' && product.category != selectedCategory) {
        return false;
      }
      if (minPrice != null && product.price < minPrice) {
        return false;
      }
      if (maxPrice != null && product.price > maxPrice) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }
}
