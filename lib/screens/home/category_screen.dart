import 'package:flutter/material.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/product_model.dart';
import '../../services/product_repository.dart';
import '../widgets/animated_product_card.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: FutureBuilder<List<Product>>(
        future: ProductRepository().fetchProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bool showAll = categoryName.toLowerCase() == 'all';
          final String normalizedCategory = categoryName.toLowerCase();
          final filteredProducts = snapshot.data!.where((product) {
            if (showAll) {
              return true;
            }
            if (product.category.toLowerCase() == normalizedCategory) {
              return true;
            }
            return product.name.toLowerCase().contains(normalizedCategory);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return AnimatedProductCard(
                  product: product,
                  onTap: () {
                    AppNavigator.toProductDetails(context, product);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
