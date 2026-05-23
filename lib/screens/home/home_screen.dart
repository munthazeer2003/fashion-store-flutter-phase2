import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/constants.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/category_chips_strip.dart';
import '../widgets/store_image.dart';
import '../widgets/store_search_bar.dart';
import '../../view_models/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);
    const backgroundColor = Color(0xFFF7F7F7);

    return ViewModelBuilder<HomeViewModel>(
      create: (_) => HomeViewModel(),
      builder: (context, viewModel, child) {
        Future.microtask(viewModel.loadProducts);
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, viewModel.userName),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                  const SizedBox(height: 18),
                  StoreSearchBar(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.allProducts);
                    },
                    onFilterTap: () {
                      Navigator.pushNamed(context, AppRoutes.allProducts);
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 18),
                  _buildPromoCard(context, accentColor),
                  const SizedBox(height: 22),
                  _buildSectionHeader(
                    title: 'Popular Product',
                    actionText: 'See all',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.allProducts),
                  ),
                  const SizedBox(height: 12),
                  _buildPopularProducts(viewModel, accentColor),
                  const SizedBox(height: 22),
                  _buildSectionHeader(
                    title: 'New Arrivals',
                    actionText: 'Explore',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.allProducts),
                  ),
                  const SizedBox(height: 12),
                  _buildProductGrid(viewModel),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $userName',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              const Text(
                'Good Morning',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.notifications);
          },
          icon: const Icon(Icons.notifications_none),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
      ],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
              Navigator.pushNamed(context, AppRoutes.shopping);
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

  Widget _buildPopularProducts(HomeViewModel viewModel, Color accentColor) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.popularProducts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = viewModel.popularProducts[index];
          return GestureDetector(
            onTap: () {
              AppNavigator.toProductDetails(context, product);
            },
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: StoreImage(
                        image: product.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppConstants.currency} ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(HomeViewModel viewModel) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.newArrivals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = viewModel.newArrivals[index];
        return GestureDetector(
          onTap: () {
            AppNavigator.toProductDetails(context, product);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: StoreImage(
                      image: product.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppConstants.currency} ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return AppBottomNavigationBar(
      currentIndex: 0,
      profileLabel: 'Account',
      onTap: (index) {
        AppNavigator.switchBottomTab(context, index);
      },
    );
  }
}
