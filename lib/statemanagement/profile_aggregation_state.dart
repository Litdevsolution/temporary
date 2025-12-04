import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:temporary/models/profile_aggregation_model.dart';
import 'package:temporary/repository/repository.dart';

class ProfileAggregationState extends GetxController {
  final Repository repository = Repository();

  var isLoading = true.obs;
  var total = 0.obs;
  var female = 0.obs;
  var male = 0.obs;
  var newProfilesCount = 0.obs;
  var applicationCount = 0.obs;
  var neverApplication = 0.obs;

  void testValues() {
    total.value = 100;
    female.value = 40;
    male.value = 60;
    newProfilesCount.value = 10;
    debugPrint(
      '✅ Test values set - '
      'Total: $total, '
      'Female: $female, '
      'Male: $male, '
      'New: $newProfilesCount',
    );
  }

  Future<void> fetchProfileAggregation({
    required String startDate,
    required String endDate,
  }) async {
    try {
      isLoading.value = true;

      final apiUrl =
          '${repository.uri}/${repository.profile_aggregations}?start=$startDate&end=$endDate';
      debugPrint('🌐 API URL: $apiUrl');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('🔵 Response Status: ${response.statusCode}');
      debugPrint('🔵 Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          debugPrint('🟢 Parsed JSON: $data');

          // Handle different response structures
          final responseData = data['result'] ?? data['data'] ?? data;
          debugPrint('🟢 Extracted Data: $responseData');

          if (responseData is Map<String, dynamic>) {
            final profileData = ProfileAggregationModel.fromJson(responseData);
            total.value = profileData.total;
            female.value = profileData.female;
            male.value = profileData.male;
            newProfilesCount.value = profileData.newProfilesCount;
            applicationCount.value = profileData.applicationCount;
            neverApplication.value = profileData.neverApplication;
          } else {
            debugPrint('⚠️ Unexpected data format: $responseData');
          }
        } catch (e) {
          debugPrint('❌ JSON Parsing Error: $e');
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
