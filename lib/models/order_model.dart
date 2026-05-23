enum OrderStatus { active, completed, cancelled }

class OrderItem {
  OrderItem({
    required this.id,
    required this.itemsCount,
    required this.total,
    required this.image,
    required this.status,
  });

  final String id;
  final int itemsCount;
  final double total;
  final String image;
  final OrderStatus status;
}
