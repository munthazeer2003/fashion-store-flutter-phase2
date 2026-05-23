import 'package:flutter/material.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../models/order_model.dart';
import '../../view_models/my_orders_view_model.dart';
import '../widgets/store_image.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);
    return DefaultTabController(
      length: 3,
      child: ViewModelBuilder<MyOrdersViewModel>(
        create: (_) => MyOrdersViewModel(),
        builder: (context, viewModel, child) {
          Future.microtask(viewModel.loadOrders);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
              title: const Text(
                'My Orders',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(44),
                child: TabBar(
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2, color: Color(0xFFF26B3A)),
                    insets: EdgeInsets.symmetric(horizontal: 18),
                  ),
                  labelColor: accentColor,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'Active'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ),
            ),
            body: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _buildOrdersList(
                        viewModel.ordersForStatus(OrderStatus.active),
                        accentColor,
                      ),
                      _buildOrdersList(
                        viewModel.ordersForStatus(OrderStatus.completed),
                        accentColor,
                      ),
                      _buildOrdersList(
                        viewModel.ordersForStatus(OrderStatus.cancelled),
                        accentColor,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderItem> orders, Color accentColor) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders here yet',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order, accentColor);
      },
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    OrderItem order,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: StoreImage(image: order.image, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.itemsCount} items - LKR ${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackground(order.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusLabel(order.status),
                        style: TextStyle(
                          color: statusText(order.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 16, color: Color(0xFFEDEDED)),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(order: order),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: accentColor),
              child: const Text(
                'View Details',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color statusBackground(OrderStatus status) {
  switch (status) {
    case OrderStatus.active:
      return const Color(0xFFE4F4F7);
    case OrderStatus.completed:
      return const Color(0xFFEAF7EC);
    case OrderStatus.cancelled:
      return const Color(0xFFFFEFEF);
  }
}

Color statusText(OrderStatus status) {
  switch (status) {
    case OrderStatus.active:
      return const Color(0xFF3B9FB1);
    case OrderStatus.completed:
      return const Color(0xFF3B8A4B);
    case OrderStatus.cancelled:
      return const Color(0xFFC23B3B);
  }
}

String statusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.active:
      return 'Active';
    case OrderStatus.completed:
      return 'Completed';
    case OrderStatus.cancelled:
      return 'Cancelled';
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final OrderItem order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Order ${order.id}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: StoreImage(
                        image: order.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${order.itemsCount} items - LKR ${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackground(order.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusLabel(order.status),
                        style: TextStyle(
                          color: statusText(order.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Total: LKR ${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Orders',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
