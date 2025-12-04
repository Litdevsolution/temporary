import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:temporary/models/profile_donut_chart_model.dart';
import 'package:temporary/repository/repository.dart';
class ProfileDonutChartState extends GetxController {
  final Repository repository = Repository();
  var nationalityList = <ProfileDonutChartModel>[].obs;

  Future<void> fetchNationalityCounts() async {
    try {
      final apiUrl = '${repository.uri}/${repository.profile_donut_chart}';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final result = data['result'] as List<dynamic>? ?? [];

        nationalityList.value = result
            .map((e) => ProfileDonutChartModel.fromJson(e))
            .toList();
      } else {
        debugPrint('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network Error: $e');
    }
  }
}
