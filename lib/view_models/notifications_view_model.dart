import 'package:flutter/material.dart';
import '../core/mvvm/base_view_model.dart';

class NotificationsViewModel extends BaseViewModel {
  final List<NotificationItem> _items = [
    NotificationItem(
      title: 'Order Confirmed!',
      message: 'Your order #12345 has been confirmed\nand is being processed.',
      time: '2 minutes ago',
      icon: Icons.shopping_bag_outlined,
      iconColor: const Color(0xFFEF6C4D),
      cardColor: const Color(0xFFFBEAE4),
      circleColor: const Color(0xFFF8D8CE),
    ),
    NotificationItem(
      title: 'Special Offer!',
      message: 'Get 20% off on all shoes this weekend!',
      time: '1 hour ago',
      icon: Icons.local_offer_outlined,
      iconColor: const Color(0xFFED9A3A),
      cardColor: Colors.white,
      circleColor: const Color(0xFFF6E1C4),
    ),
    NotificationItem(
      title: 'Out for Delivery',
      message: 'Your order #12344 is out for delivery.',
      time: '3 hours ago',
      icon: Icons.local_shipping_outlined,
      iconColor: const Color(0xFF61B36D),
      cardColor: Colors.white,
      circleColor: const Color(0xFFDFF1E3),
    ),
    NotificationItem(
      title: 'Payment Successful',
      message: 'Payment for order #12345 was successful.',
      time: '5 hours ago',
      icon: Icons.credit_card_outlined,
      iconColor: const Color(0xFFE26A7A),
      cardColor: Colors.white,
      circleColor: const Color(0xFFF7D6DC),
    ),
  ];

  List<NotificationItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.cardColor,
    required this.circleColor,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color cardColor;
  final Color circleColor;
}
