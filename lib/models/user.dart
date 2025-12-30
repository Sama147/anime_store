class User {
  final int Uid;
  final String firstName;
  final String lastName;
  final int? age;
  final String? gender;
  final String email;
  final String role;
  final int? addressId;

  User({
    required this.Uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.addressId,
    this.age,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Maps Uid from database
      Uid: json['Uid'] as int,
      firstName: json['firstName'] as String? ?? 'Guest',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      // Maps Uage and Ugender from database
      age: json['Uage'] as int?,
      gender: json['Ugender'] as String?,
      role: json['role'] as String? ?? 'customer',
      addressId: json['Aid'] as int?,
    );
  }
}