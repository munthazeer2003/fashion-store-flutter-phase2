import '../core/mvvm/base_view_model.dart';
import '../models/order_model.dart';
import '../services/order_repository.dart';

class MyOrdersViewModel extends BaseViewModel {
  MyOrdersViewModel({OrderRepository? orderRepository})
    : _orderRepository = orderRepository ?? OrderRepository();

  final OrderRepository _orderRepository;
  bool _loaded = false;
  final List<OrderItem> _orders = [
    OrderItem(
      id: '#1234',
      itemsCount: 2,
      total: 299.99,
      image: 'assets/images/products/shoes/shoe_1.jpg',
      status: OrderStatus.active,
    ),
    OrderItem(
      id: '#1235',
      itemsCount: 1,
      total: 89.50,
      image: 'assets/images/products/shoes/shoe_2.jpg',
      status: OrderStatus.active,
    ),
    OrderItem(
      id: '#1236',
      itemsCount: 3,
      total: 159.75,
      image: 'assets/images/products/women/women_dress_1.jpg',
      status: OrderStatus.completed,
    ),
    OrderItem(
      id: '#1237',
      itemsCount: 1,
      total: 49.99,
      image: 'assets/images/products/men/men_shirt_1.jpg',
      status: OrderStatus.cancelled,
    ),
  ];

  List<OrderItem> ordersForStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<void> loadOrders() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      final firebaseOrders = await _orderRepository.fetchUserOrders();
      if (firebaseOrders.isNotEmpty) {
        _orders
          ..clear()
          ..addAll(firebaseOrders);
      }
      clearError();
    } catch (_) {
      setError('Could not load Firebase orders. Showing local orders.');
    } finally {
      setBusy(false);
    }
  }
}
