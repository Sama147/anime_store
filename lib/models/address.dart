class Address {
  final int id;
  final String city;
  final String street;
  final String building;

  Address({
    required this.id,
    required this.city,
    required this.street,
    required this.building,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int,
      city: json['city'] as String,
      street: json['street'] as String,
      building: json['building'] as String,
    );
  }
}