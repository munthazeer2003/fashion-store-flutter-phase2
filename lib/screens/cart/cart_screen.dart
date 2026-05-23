import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../view_models/cart_view_model.dart';
import '../widgets/empty_state.dart';
import '../widgets/store_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);
    return ViewModelBuilder<CartViewModel>(
      create: (_) => CartViewModel(),
      builder: (context, viewModel, child) {
        Future.microtask(viewModel.loadCart);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('My Cart'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : viewModel.items.isEmpty
              ? EmptyState(
                  title: 'Your cart is empty',
                  message: 'Add products to checkout with Firebase cart.',
                  actionLabel: 'Shop Products',
                  onAction: () {
                    Navigator.pushNamed(context, AppRoutes.allProducts);
                  },
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: viewModel.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    return _buildCartRow(item, accentColor, index, viewModel);
                  },
                ),
          bottomNavigationBar: _buildSummaryBar(
            context,
            accentColor,
            viewModel,
          ),
        );
      },
    );
  }

  Widget _buildSummaryBar(
    BuildContext context,
    Color accentColor,
    CartViewModel viewModel,
  ) {
    final total = viewModel.total;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LKR ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: viewModel.items.isEmpty
                  ? null
                  : () {
                      Navigator.pushNamed(context, AppRoutes.checkout);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartRow(
    CartItem item,
    Color accentColor,
    int index,
    CartViewModel viewModel,
  ) {
    return Container(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: StoreImage(
              image: item.image,
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'LKR ${item.price.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  viewModel.removeAt(index);
                },
                icon: Icon(Icons.delete_outline, color: accentColor),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE9E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQtyButton(
                      icon: Icons.remove,
                      onTap: () => viewModel.decrement(index),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    _buildQtyButton(
                      icon: Icons.add,
                      onTap: () => viewModel.increment(index),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Icon(icon, size: 16, color: const Color(0xFFF26B3A)),
      ),
    );
  }
}
