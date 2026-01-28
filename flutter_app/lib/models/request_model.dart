class ServiceRequest {
  final String serviceType;
  final String carModel;
  final String plateNumber;
  final String notes;
  final double latitude;
  final double longitude;
  final int? price; // السعر بالريال
  final String? userId; // معرف المستخدم (Firebase UID)

  ServiceRequest({
    required this.serviceType,
    required this.carModel,
    required this.plateNumber,
    required this.notes,
    required this.latitude,
    required this.longitude,
    this.price,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "serviceType": serviceType,
      "carModel": carModel,
      "plateNumber": plateNumber,
      "notes": notes,
      "latitude": latitude,
      "longitude": longitude,
      "price": price,
      "userId": userId,
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
      price: json['price'] != null ? (json['price'] as num).toInt() : null,
      userId: json['userId']?.toString(),
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
  final int? price; // السعر بالريال
  final int? estimatedArrivalMinutes; // الوقت المتوقع للوصول بالدقائق
  final DateTime? estimatedArrivalTimestamp; // وقت الوصول المتوقع
  final String? technicianId; // معرف الفني
  final int? rating; // التقييم (1-5)
  final String? review; // التعليق النصي

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
    this.price,
    this.estimatedArrivalMinutes,
    this.estimatedArrivalTimestamp,
    this.technicianId,
    this.rating,
    this.review,
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

    // معالجة estimatedArrivalTimestamp
    DateTime? parseEstimatedArrivalTimestamp(dynamic dateValue) {
      if (dateValue == null) return null;

      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return null;
        }
      }

      if (dateValue is DateTime) {
        return dateValue;
      }

      if (dateValue is Map) {
        if (dateValue['seconds'] != null) {
          final seconds = dateValue['seconds'] as int;
          final nanoseconds = (dateValue['nanoseconds'] as int?) ?? 0;
          return DateTime.fromMillisecondsSinceEpoch(
            seconds * 1000 + (nanoseconds ~/ 1000000),
          );
        }
        if (dateValue['_seconds'] != null) {
          final seconds = dateValue['_seconds'] as int;
          return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        }
      }

      return null;
    }

    // معالجة estimatedArrivalMinutes
    int? parseEstimatedArrivalMinutes(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed;
      }
      return null;
    }

    final estimatedMinutes = parseEstimatedArrivalMinutes(
      json['estimatedArrivalMinutes'],
    );

    // Debug logging
    if (json['id'] != null) {
      print(
        '🔍 Parsing Order ${json['id']}: estimatedArrivalMinutes=${json['estimatedArrivalMinutes']} (type: ${json['estimatedArrivalMinutes'].runtimeType}) -> parsed: $estimatedMinutes',
      );
    }

    // معالجة rating
    int? parseRating(dynamic value) {
      if (value == null) return null;
      if (value is int) return value >= 1 && value <= 5 ? value : null;
      if (value is num) {
        final intValue = value.toInt();
        return intValue >= 1 && intValue <= 5 ? intValue : null;
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed != null && parsed >= 1 && parsed <= 5 ? parsed : null;
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
      price: json['price'] != null ? (json['price'] as num).toInt() : null,
      estimatedArrivalMinutes: estimatedMinutes,
      estimatedArrivalTimestamp: parseEstimatedArrivalTimestamp(
        json['estimatedArrivalTimestamp'],
      ),
      technicianId: json['technicianId'],
      rating: parseRating(json['rating']),
      review: json['review'],
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
