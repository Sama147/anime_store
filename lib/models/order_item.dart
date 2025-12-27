// lib/models/order_item.dart

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double priceAtPurchase;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      priceAtPurchase: (json['priceAtPurchase'] as num).toDouble(),
    );
  }
}