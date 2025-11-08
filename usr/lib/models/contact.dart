class Contact {
  final String id;
  final String name;
  final String phone;
  final String role;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.role = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String? ?? '',
    );
  }
}
