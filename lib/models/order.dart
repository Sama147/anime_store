// lib/models/order.dart

class Order {
  final int id;
  final int userId;
  final DateTime date;
  final double amount;

  Order({
    required this.id,
    required this.userId,
    required this.date,
    required this.amount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}