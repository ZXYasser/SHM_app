import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ApiService {
  // تسجيل دخول الفني
  static Future<Map<String, dynamic>> technicianLogin(
    String phone,
    String password,
  ) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.technicianLoginEndpoint}',
    );

    try {
      print('📤 Technician login to: $url');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'phone': phone,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          print('✅ Login successful!');
          return {
            'success': true,
            'id': data['id'],
            'name': data['name'],
          };
        } else {
          return {
            'success': false,
            'error': data['message'] ?? 'بيانات الدخول غير صحيحة',
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
        'error': 'انتهت مهلة الاتصال. تحقق من اتصالك بالإنترنت.',
      };
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'error': 'فشل الاتصال بالخادم. تأكد من أن الخادم يعمل.',
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
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Error fetching requests: $e');
      return [];
    }
  }

  // تحديث حالة الطلب
  static Future<Map<String, dynamic>> updateRequestStatus(
    String requestId,
    String status, {
    String? technicianId,
  }) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.updateRequestEndpoint}/$requestId',
    );

    try {
      print('📤 Updating request $requestId to status: $status');

      final body = <String, dynamic>{'status': status};
      if (technicianId != null) {
        body['technicianId'] = technicianId;
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

  // حذف طلب
  static Future<Map<String, dynamic>> deleteRequest(String requestId) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.updateRequestEndpoint}/$requestId',
    );

    try {
      print('🗑️  Deleting request $requestId');

      final response = await http
          .delete(url)
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'] ?? 'تم الحذف بنجاح',
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'فشل الحذف',
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
      print('❌ Error deleting request: $e');
      return {
        'success': false,
        'error': 'فشل الاتصال بالخادم.',
      };
    }
  }
}
