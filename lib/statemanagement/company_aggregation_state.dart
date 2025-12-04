import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:temporary/repository/repository.dart';

class CompanyAggregationState extends GetxController {
  final Repository repository = Repository();

  var isLoading = true.obs;
  var totalCount = 0.obs; // ✅ Correct declaration

  void testValues() {
    totalCount.value = 100;
    debugPrint('✅ Test values set - totalCount: ${totalCount.value}');
  }

  Future<void> fetchCompanyAggregation() async {
    try {
      isLoading.value = true;

      final apiUrl = '${repository.uri}/${repository.company}';
      debugPrint('🌐 API URL: $apiUrl');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('🔵 Response Status: ${response.statusCode}');
      debugPrint('🔵 Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // ✅ Get totalCount from meta
        totalCount.value = data['meta']?['totalCount'] ?? 0;
        debugPrint('✅ Total company count: ${totalCount.value}');

        // Optional: debug result array
        if (data['result'] != null) {
          debugPrint('🟢 Result array length: ${(data['result'] as List).length}');
        }
      } else {
        debugPrint('❌ API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
