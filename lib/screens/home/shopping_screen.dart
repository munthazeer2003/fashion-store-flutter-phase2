import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/constants.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../models/product_model.dart';
import '../../view_models/shopping_view_model.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/category_chips_strip.dart';
import '../widgets/store_image.dart';
import '../widgets/store_search_bar.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);
    const backgroundColor = Color(0xFFF6F6F6);

    return ViewModelBuilder<ShoppingViewModel>(
      create: (_) => ShoppingViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Shopping',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.allProducts);
                },
                icon: const Icon(Icons.search, color: Colors.black87),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreSearchBar(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.allProducts);
                    },
                    onFilterTap: () {
                      Navigator.pushNamed(context, AppRoutes.allProducts);
                    },
                  ),
                  const SizedBox(height: 14),
                  CategoryChipsStrip(
                    categories: viewModel.categories,
                    selectedIndex: viewModel.selectedCategoryIndex,
                    onTap: (index, category) {
                      viewModel.selectCategory(index);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.category,
                        arguments: category,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPromoCard(context, accentColor),
                  const SizedBox(height: 20),
                  _buildSectionHeader(
                    title: 'Popular Product',
                    actionText: 'See All',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.allProducts),
                  ),
                  const SizedBox(height: 12),
                  _buildPopularProducts(viewModel, accentColor),
                  const SizedBox(height: 18),
                  _buildSectionHeader(
                    title: 'New Arrivals',
                    actionText: 'Explore',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.allProducts),
                  ),
                  const SizedBox(height: 12),
                  _buildProductGrid(viewModel, accentColor),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildPromoCard(BuildContext context, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Your',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Special Sale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Up to 40%',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.allProducts);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Shop Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProducts(ShoppingViewModel viewModel, Color accentColor) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.popularProducts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = viewModel.popularProducts[index];
          return _buildProductCard(context, product, accentColor, width: 150);
        },
      ),
    );
  }

  Widget _buildProductGrid(ShoppingViewModel viewModel, Color accentColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.newArrivals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final product = viewModel.newArrivals[index];
        return _buildProductCard(context, product, accentColor);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    Color accentColor, {
    double? width,
  }) {
    final double oldPrice = product.price * 1.2;
    return GestureDetector(
      onTap: () {
        AppNavigator.toProductDetails(context, product);
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: StoreImage(
                        image: product.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '10% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.wishlist);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.black87,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              product.category,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${AppConstants.currency} ${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${AppConstants.currency} ${oldPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return AppBottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        AppNavigator.switchBottomTab(context, index);
      },
    );
  }
}
