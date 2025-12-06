class Technician {
  final String id;
  final String name;
  final String phone;
  final String? status;
  final DateTime? createdAt;

  Technician({
    required this.id,
    required this.name,
    required this.phone,
    this.status,
    this.createdAt,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    if (json['createdAt'] != null) {
      if (json['createdAt'] is Map) {
        if (json['createdAt']['seconds'] != null) {
          createdAt = DateTime.fromMillisecondsSinceEpoch(
            json['createdAt']['seconds'] * 1000,
          );
        }
      } else if (json['createdAt'] is String) {
        createdAt = DateTime.parse(json['createdAt']);
      }
    }

    return Technician(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

