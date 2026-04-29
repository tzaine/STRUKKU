// lib/core/models/receipt_item.dart

class ReceiptItem {
  final String name;
  final double price;
  final int? quantity;

  const ReceiptItem({
    required this.name,
    required this.price,
    this.quantity,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        if (quantity != null) 'quantity': quantity,
      };

  ReceiptItem copyWith({String? name, double? price, int? quantity}) {
    return ReceiptItem(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
