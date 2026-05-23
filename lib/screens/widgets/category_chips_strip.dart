import 'package:flutter/material.dart';

import 'category_chip.dart';

class CategoryChipsStrip extends StatelessWidget {
  const CategoryChipsStrip({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> categories;
  final int selectedIndex;
  final void Function(int index, String category) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return CategoryChip(
            title: categories[index],
            isSelected: selectedIndex == index,
            onTap: () => onTap(index, categories[index]),
          );
        },
      ),
    );
  }
}