import '../data/dummy_products.dart';
import '../models/product_model.dart';
import 'product_catalog_view_model.dart';

class ShoppingViewModel extends ProductCatalogViewModel {
  List<Product> get popularProducts => dummyProducts;
  List<Product> get newArrivals => dummyProducts;
}
