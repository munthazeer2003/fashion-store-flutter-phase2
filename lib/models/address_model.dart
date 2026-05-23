class AddressItem {
  const AddressItem({
    required this.id,
    required this.title,
    required this.isDefault,
    required this.addressLine1,
    required this.addressLine2,
  });

  final String id;
  final String title;
  final bool isDefault;
  final String addressLine1;
  final String addressLine2;

  factory AddressItem.fromMap(String id, Map<String, dynamic> data) {
    return AddressItem(
      id: id,
      title: data['title'] as String? ?? 'Address',
      isDefault: data['isDefault'] as bool? ?? false,
      addressLine1: data['addressLine1'] as String? ?? '',
      addressLine2: data['addressLine2'] as String? ?? '',
    );
  }

  AddressItem copyWith({
    String? id,
    String? title,
    bool? isDefault,
    String? addressLine1,
    String? addressLine2,
  }) {
    return AddressItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDefault: isDefault ?? this.isDefault,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDefault': isDefault,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
    };
  }
}
