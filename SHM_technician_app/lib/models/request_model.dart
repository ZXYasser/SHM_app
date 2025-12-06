class OrderModel {
  final String id;
  final String serviceType;
  final String carModel;
  final String plateNumber;
  final String notes;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime? createdAt;
  final String? technicianId;

  OrderModel({
    required this.id,
    required this.serviceType,
    required this.carModel,
    required this.plateNumber,
    required this.notes,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.createdAt,
    this.technicianId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime? createdAtDate;
    
    if (json['createdAt'] != null) {
      if (json['createdAt'] is Map) {
        // Firestore Timestamp
        if (json['createdAt']['seconds'] != null) {
          createdAtDate = DateTime.fromMillisecondsSinceEpoch(
            json['createdAt']['seconds'] * 1000,
          );
        } else if (json['createdAt']['toDate'] != null) {
          // Firestore Timestamp object
          createdAtDate = DateTime.parse(json['createdAt']['toDate'].toString());
        }
      } else if (json['createdAt'] is String) {
        createdAtDate = DateTime.tryParse(json['createdAt']);
      } else if (json['createdAt'] is int) {
        createdAtDate = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
      }
    }

    return OrderModel(
      id: json['id'] ?? json['_id'] ?? '',
      serviceType: json['serviceType'] ?? '',
      carModel: json['carModel'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      notes: json['notes'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'new',
      createdAt: createdAtDate,
      technicianId: json['technicianId'],
    );
  }

  String get statusText {
    switch (status) {
      case 'new':
        return 'جديد';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }
}

