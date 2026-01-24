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
  final int? estimatedArrivalMinutes;
  final DateTime? estimatedArrivalTimestamp;

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
    this.estimatedArrivalMinutes,
    this.estimatedArrivalTimestamp,
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

    DateTime? parseEstimatedArrivalTimestamp(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is Map) {
        if (dateValue['seconds'] != null) {
          return DateTime.fromMillisecondsSinceEpoch(
            dateValue['seconds'] * 1000,
          );
        }
        if (dateValue['toDate'] != null) {
          return DateTime.parse(dateValue['toDate'].toString());
        }
      } else if (dateValue is String) {
        return DateTime.tryParse(dateValue);
      } else if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      } else if (dateValue is DateTime) {
        return dateValue;
      }
      return null;
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
      estimatedArrivalMinutes: json['estimatedArrivalMinutes'] != null 
          ? (json['estimatedArrivalMinutes'] as num).toInt() 
          : null,
      estimatedArrivalTimestamp: parseEstimatedArrivalTimestamp(json['estimatedArrivalTimestamp']),
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

