import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:staypermitappv1/repository/repository.dart';

class ScanState {
  final Repository repository = Repository();

  /// Fetch application data by barcode
  /// This is now an **instance method**, so it can access `repository`.
  Future<Map<String, dynamic>?> fetchApplicationByBarcode({
    required String barcode,
    required String status,
    required String authorizationToken,
  }) async {
    final String apiUrl =
        '${repository.uri}/${repository.application}?barcode=$barcode&status=$status';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authorizationToken,
          'Accept': 'application/json',
        },
      );

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
        throw Exception(
          'โหลดข้อมูลล้มเหลว (Status Code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('❌ ข้อผิดพลาดในการดึงข้อมูลสำหรับบาร์โค้ด [$barcode]: $e');
      throw Exception('ข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }
}
