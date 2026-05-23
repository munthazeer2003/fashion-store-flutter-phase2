class PaymentMethodItem {
  const PaymentMethodItem({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.holderName,
    required this.isDefault,
    required this.type,
  });

  final String id;
  final String brand;
  final String last4;
  final String expiry;
  final String holderName;
  final bool isDefault;
  final String type;

  bool get isCash => type == 'cash';
  bool get isOnline => type == 'online';

  String get title {
    if (isCash || isOnline) {
      return brand;
    }
    return '$brand ending in $last4';
  }

  String get subtitle => expiry.isEmpty ? holderName : '$holderName - $expiry';

  factory PaymentMethodItem.cashOnDelivery() {
    return const PaymentMethodItem(
      id: '',
      brand: 'Cash on Delivery',
      last4: 'COD',
      expiry: '',
      holderName: 'Pay when your order arrives',
      isDefault: true,
      type: 'cash',
    );
  }

  factory PaymentMethodItem.onlinePayment() {
    return const PaymentMethodItem(
      id: '',
      brand: 'Online Payment',
      last4: 'ONLINE',
      expiry: '',
      holderName: 'Pay securely online',
      isDefault: false,
      type: 'online',
    );
  }

  factory PaymentMethodItem.fromMap(String id, Map<String, dynamic> data) {
    return PaymentMethodItem(
      id: id,
      brand: data['brand'] as String? ?? 'Card',
      last4: data['last4'] as String? ?? '0000',
      expiry: data['expiry'] as String? ?? '',
      holderName: data['holderName'] as String? ?? 'Card Holder',
      isDefault: data['isDefault'] as bool? ?? false,
      type: data['type'] as String? ?? _inferType(data),
    );
  }

  PaymentMethodItem copyWith({
    String? id,
    String? brand,
    String? last4,
    String? expiry,
    String? holderName,
    bool? isDefault,
    String? type,
  }) {
    return PaymentMethodItem(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expiry: expiry ?? this.expiry,
      holderName: holderName ?? this.holderName,
      isDefault: isDefault ?? this.isDefault,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'last4': last4,
      'expiry': expiry,
      'holderName': holderName,
      'isDefault': isDefault,
      'type': type,
    };
  }

  static String _inferType(Map<String, dynamic> data) {
    final brand = (data['brand'] as String? ?? '').toLowerCase();
    final last4 = (data['last4'] as String? ?? '').toLowerCase();
    if (brand.contains('cash') || last4 == 'cod') {
      return 'cash';
    }
    if (brand.contains('online') || last4 == 'online') {
      return 'online';
    }
    return 'card';
  }
}
