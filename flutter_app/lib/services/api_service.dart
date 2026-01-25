import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../models/request_model.dart';

class ApiService {
  // إرسال طلب جديد
  static Future<Map<String, dynamic>> submitRequest(
    ServiceRequest request,
  ) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.newRequestEndpoint}',
    );

    try {
      print('📤 Sending request to: $url');
      print('📦 Request data: ${jsonEncode(request.toJson())}');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          print('✅ Request sent successfully!');
          return {
            'success': true,
            'message': data['message'] ?? 'تم إرسال الطلب بنجاح',
            'id': data['id'],
            'data': data['data'],
          };
        } else {
          print('❌ Request failed: ${data['error']}');
          return {
            'success': false,
            'error': data['error'] ?? 'حدث خطأ غير متوقع',
          };
        }
      } else {
        // محاولة قراءة error من response
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'error':
                errorData['error'] ??
                'حدث خطأ في الخادم (${response.statusCode})',
          };
        } catch (e) {
          return {
            'success': false,
            'error': 'حدث خطأ في الخادم (${response.statusCode})',
          };
        }
      }
    } on TimeoutException {
      print('⏱️ Request timeout');
      return {
        'success': false,
        'error': 'انتهت مهلة الاتصال. تحقق من اتصالك بالإنترنت.',
      };
    } on http.ClientException catch (e) {
      print('❌ ClientException: ${e.message}');
      String errorMessage;
      if (kIsWeb) {
        errorMessage = 'فشل الاتصال بالخادم.\n\n'
            'تأكد من:\n'
            '1. أن الخادم يعمل على http://localhost:3000\n'
            '2. قم بتشغيل: cd SHM_backend && node server.js';
      } else {
        errorMessage = 'فشل الاتصال بالخادم.\n\n'
            'تأكد من:\n'
            '1. أن الخادم يعمل على ${AppConstants.baseUrl}\n'
            '2. أنك متصل بنفس الشبكة';
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error: $e');
      String errorMessage;
      if (kIsWeb) {
        errorMessage = 'فشل الاتصال بالخادم.\n\n'
            'تأكد من أن الخادم يعمل على http://localhost:3000\n'
            'قم بتشغيل: cd SHM_backend && node server.js';
      } else {
        errorMessage = 'فشل الاتصال بالخادم. تأكد من أن الخادم يعمل وأنك متصل بالشبكة.';
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  // جلب جميع الطلبات
  static Future<List<dynamic>> getRequests() async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.requestsEndpoint}',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Log for debugging
        if (data is List && data.isNotEmpty) {
          print('📥 Fetched ${data.length} requests');
          for (var request in data.take(5)) {
            print('   Request ${request['id']}: status=${request['status']}, estimatedArrivalMinutes=${request['estimatedArrivalMinutes']}, estimatedArrivalTimestamp=${request['estimatedArrivalTimestamp']}');
          }
        }
        return data;
      } else {
        print('❌ Failed to fetch requests: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching requests: $e');
      return [];
    }
  }

  // تحديث حالة الطلب (لإلغاء الطلب)
  static Future<Map<String, dynamic>> updateRequestStatus(
    String requestId,
    String status,
  ) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.updateRequestEndpoint}/$requestId',
    );

    try {
      print('📤 Updating request $requestId to status: $status');

      final response = await http
          .patch(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'status': status}),
          )
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'] ?? 'تم التحديث بنجاح',
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'فشل التحديث',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'حدث خطأ في الخادم (${response.statusCode})',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'error': 'انتهت مهلة الاتصال.',
      };
    } catch (e) {
      print('❌ Error updating request: $e');
      return {
        'success': false,
        'error': 'فشل الاتصال بالخادم.',
      };
    }
  }

  // إرسال التقييم والمراجعة
  static Future<Map<String, dynamic>> submitRating(
    String requestId,
    int rating,
    String? review,
  ) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.updateRequestEndpoint}/$requestId',
    );

    try {
      print('⭐ Submitting rating for request $requestId: $rating stars');

      final body = <String, dynamic>{
        'rating': rating,
      };
      if (review != null && review.trim().isNotEmpty) {
        body['review'] = review.trim();
      }

      final response = await http
          .patch(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'] ?? 'تم إرسال التقييم بنجاح',
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'فشل إرسال التقييم',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'حدث خطأ في الخادم (${response.statusCode})',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'error': 'انتهت مهلة الاتصال.',
      };
    } catch (e) {
      print('❌ Error submitting rating: $e');
      return {
        'success': false,
        'error': 'فشل الاتصال بالخادم.',
      };
    }
  }
}
