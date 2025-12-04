import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:temporary/repository/repository.dart';

class ScanState {
  final Repository repository = Repository();
  final Duration timeout = const Duration(seconds: 30);

  /// Fetch application data by barcode
  /// This is now an **instance method**, so it can access `repository`.
  Future<Map<String, dynamic>?> fetchApplicationByBarcode({
    required String barcode,
    required String status,
    required String authorizationToken,
  }) async {
    final String apiUrl =
        '${repository.uri}/${repository.application}?barcode=$barcode&status=$status';
    print('⌛ Fetching API: $apiUrl');
    print('🔑 Token: ${authorizationToken.substring(0, 20)}...');  // Only show first 20 chars of token


    try {
      // Validate token
      if (authorizationToken.isEmpty || !authorizationToken.startsWith('Bearer ')) {
        throw Exception('Token ບໍ່ຖືກຕ້ອງ ກະລຸນາເຂົ້າສູ່ລະບົບໃໝ່');
      }

      // Validate barcode
      if (barcode.isEmpty) {
        throw Exception('ກະລຸນາລະບຸລະຫັດ Barcode');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authorizationToken,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return null;

        final decodedData = json.decode(response.body);

        if (decodedData is Map<String, dynamic> &&
            decodedData.containsKey('result')) {
          final result = decodedData['result'];

          if (result == null || result.isEmpty) return null;

          if (result is List && result.isNotEmpty) {
            return Map<String, dynamic>.from(result.first);
          } else if (result is Map<String, dynamic>) {
            return result;
          } else {
            throw Exception('รูปแบบข้อมูล result จาก API ไม่ถูกต้อง');
          }
        } else {
          throw Exception('โครงสร้างข้อมูลจาก API ไม่ถูกต้อง');
        }
      } else {
        print('Server response: ${response.body}');
        if (response.statusCode == 500) {
          throw Exception('เซิร์ฟเวอร์มีข้อผิดพลาด (Status Code: 500). กรุณาลองใหม่อีกครั้ง หรือติดต่อผู้ดูแลระบบ');
        } else if (response.statusCode == 401) {
          throw Exception('ไม่มีสิทธิ์เข้าถึงข้อมูล กรุณาเข้าสู่ระบบใหม่');
        } else {
          throw Exception('โหลดข้อมูลล้มเหลว (Status Code: ${response.statusCode})\n${response.body}');
        }
      }
    } catch (e) {
      print('❌ ข้อผิดพลาดในการดึงข้อมูลสำหรับบาร์โค้ด [$barcode]: $e');
      throw Exception('ข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }
}
