class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double priceAtPurchase; // Stores the price at the time of order

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
      // Using .toDouble() ensures it won't crash if the database sends an integer
      priceAtPurchase: (json['priceAtPurchase'] as num).toDouble(),
    );
  }
}