class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final int quantity; // <--- NEW FIELD ADDED
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity, // <--- ADDED TO CONSTRUCTOR
    required this.imageUrl,
    required this.category,
  });

  // Factory constructor to create a Product object from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      description: json['description'] as String,
      quantity: json['quantity'] as int, // <--- MAPPED FROM API RESPONSE
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
    );
  }
}