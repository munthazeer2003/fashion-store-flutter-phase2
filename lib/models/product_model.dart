class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;

  Product({
    String? id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.description = 'Premium fashion piece selected for everyday comfort.',
  }) : id = id ?? name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] as String? ?? 'Product',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      image: data['image'] as String? ?? '',
      category: data['category'] as String? ?? 'All',
      description:
          data['description'] as String? ??
          'Premium fashion piece selected for everyday comfort.',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'category': category,
      'description': description,
    };
  }
}
