import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  final double price;

  const PriceText({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'LKR ${price.toStringAsFixed(0)}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}