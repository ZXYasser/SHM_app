class ServiceRequest {
  final String serviceType;
  final String carModel;
  final String plateNumber;
  final String notes;
  final double latitude;
  final double longitude;

  ServiceRequest({
    required this.serviceType,
    required this.carModel,
    required this.plateNumber,
    required this.notes,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "serviceType": serviceType,
      "carModel": carModel,
      "plateNumber": plateNumber,
      "notes": notes,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      serviceType: json['serviceType'] ?? '',
      carModel: json['carModel'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      notes: json['notes'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}

class OrderModel {
  final String? id;
  final String serviceType;
  final String carModel;
  final String plateNumber;
  final String notes;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime? createdAt;

  OrderModel({
    this.id,
    required this.serviceType,
    required this.carModel,
    required this.plateNumber,
    required this.notes,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // معالجة createdAt - يمكن أن يكون String أو Timestamp من Firestore
    DateTime? parseCreatedAt(dynamic dateValue) {
      if (dateValue == null) return null;

      // إذا كان String (ISO format)
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return null;
        }
      }

      // إذا كان DateTime مباشرة
      if (dateValue is DateTime) {
        return dateValue;
      }

      // إذا كان Firestore Timestamp object (مع seconds و nanoseconds)
      if (dateValue is Map) {
        if (dateValue['seconds'] != null) {
          final seconds = dateValue['seconds'] as int;
          final nanoseconds = (dateValue['nanoseconds'] as int?) ?? 0;
          return DateTime.fromMillisecondsSinceEpoch(
            seconds * 1000 + (nanoseconds ~/ 1000000),
          );
        }
        // محاولة parsing كـ ISO string من Map
        if (dateValue['_seconds'] != null) {
          final seconds = dateValue['_seconds'] as int;
          return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        }
      }

      return null;
    }

    return OrderModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      serviceType: json['serviceType'] ?? '',
      carModel: json['carModel'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      notes: json['notes'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'new',
      createdAt: parseCreatedAt(json['createdAt']),
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
