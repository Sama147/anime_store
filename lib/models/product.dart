class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String imageUrl;
  final String category;
  final int? createdByAdminId; // Nullable because some products might not have an admin ID

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.imageUrl,
    required this.category,
    this.createdByAdminId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      // FIX: Use 'as String?' and '??' to handle Null values from database
      name: json['name'] as String? ?? 'Unknown Product',

      // FIX: Use 'as num?' and '.toDouble()' to prevent crashes if price is sent as an int
      price: (json['price'] as num?)?.toDouble() ?? 0.0,

      description: json['description'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,

      // CRITICAL: Ensure the key 'image_url' matches exactly what server.dart sends
      imageUrl: json['image_url'] as String? ?? '',

      category: json['category'] as String? ?? 'General',

      // This remains nullable as per your admin tracking requirement
      createdByAdminId: json['createdByAdminId'] as int?,
    );
  }
}