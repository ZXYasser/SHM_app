class Order {
  final String id;
  final String serviceType;
  final String carModel;
  final String plateNumber;
  final String notes;
  final double latitude;
  final double longitude;
  final String status;
  final String? technicianId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? estimatedArrivalMinutes;
  final DateTime? estimatedArrivalTimestamp;

  Order({
    required this.id,
    required this.serviceType,
    required this.carModel,
    required this.plateNumber,
    required this.notes,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.technicianId,
    this.createdAt,
    this.updatedAt,
    this.estimatedArrivalMinutes,
    this.estimatedArrivalTimestamp,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is Map) {
        if (date['seconds'] != null) {
          return DateTime.fromMillisecondsSinceEpoch(date['seconds'] * 1000);
        }
        if (date['toDate'] != null) {
          return (date['toDate'] as Function).call();
        }
      } else if (date is String) {
        return DateTime.tryParse(date);
      } else if (date is DateTime) {
        return date;
      }
      return null;
    }

    return Order(
      id: json['id'] ?? json['_id'] ?? '',
      serviceType: json['serviceType'] ?? '',
      carModel: json['carModel'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      notes: json['notes'] ?? '',
      latitude: (json['latitude'] is num) ? json['latitude'].toDouble() : 0.0,
      longitude: (json['longitude'] is num) ? json['longitude'].toDouble() : 0.0,
      status: json['status'] ?? 'new',
      technicianId: json['technicianId'],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      estimatedArrivalMinutes: json['estimatedArrivalMinutes'] != null 
          ? (json['estimatedArrivalMinutes'] as num).toInt() 
          : null,
      estimatedArrivalTimestamp: parseDate(json['estimatedArrivalTimestamp']),
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
        return status;
    }
  }
}

