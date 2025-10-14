import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../repository/repository.dart';
import '../routes/route_app.dart';
import '../pages/home/home_page.dart';
import '../statemanagement/app_verification_state.dart';
import '../widgets/dialog_app_widget.dart';

class LoginState extends GetxController {
  AppVerificationState appVerificationState = Get.put(AppVerificationState());
  Repository repository = Repository();
  Future<bool> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${repository.uri}/${repository.login}');
      print('🔵 Login URL: $url');

      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // KEY FIX: Changed from 'token' to 'accessToken'
        if (responseData['accessToken'] == null) {
          print('🔴 No accessToken in response: $responseData');
          DialogAppWidget().errorToast(
            context,
            "Login successful but no accessToken received",
          );
          return false;
        }

        print('🟢 AccessToken: ${responseData['accessToken']}');
        final user = responseData['user'];
        final role =
            user['role'] ?? 'USER'; // safely fallback if role not found

        await appVerificationState.setTokens(
          accessToken: responseData['accessToken'],
          refreshToken: responseData['refreshToken'],
          user: responseData['user'],
        );
        DialogAppWidget().showsuccessToast(
          context,
          responseData['message'] ?? 'Login successful',
        );
        Get.offAllNamed(RouteApp.home, arguments: {'role': role});
        return true;
      } else {
        final errorMsg = responseData['message'] ?? 'Login failed';
        DialogAppWidget().errorToast(context, errorMsg);
        return false;
      }
    } catch (e) {
      print('🔴 Login error: $e');
      DialogAppWidget().errorToast(context, "Connection error");
      return false;
    }
  }
}
