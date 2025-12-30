class Order {
  final int id;
  final int userId;
  final DateTime orderDate;
  final double totalAmount;
  final String status; // 'Pending', 'Cancelled', 'Completed'

  Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      userId: json['userId'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}