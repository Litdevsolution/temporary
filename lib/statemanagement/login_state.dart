import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/repository.dart';
import '../routes/route_app.dart';
import '../pages/home/home_page.dart';
import '../statemanagement/app_verification_state.dart';
import '../widgets/dialog_app_widget.dart';
import 'package:http/http.dart' as http;

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
        if (responseData['accessToken'] == null) {
          DialogAppWidget().errorToast(
            context,
            "Login successful but no accessToken received",
          );
          return false;
        }

        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];
        final user = responseData['user'];
        final role = user['role'] ?? 'USER';

        // ✅ Save tokens & user info locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('user', jsonEncode(user));

        // Set in AppVerificationState
        await appVerificationState.setTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          user: user,
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

  /// ✅ Check if user is already logged in
  Future<bool> checkRememberLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userJson = prefs.getString('user');

    if (accessToken != null && userJson != null) {
      final user = jsonDecode(userJson);
      final role = user['role'] ?? 'USER';

      // Set in AppVerificationState
      await appVerificationState.setTokens(
  accessToken: accessToken,
  refreshToken: prefs.getString('refreshToken') ?? '',
  user: user,
);


      // Navigate directly to Home
      Get.offAllNamed(RouteApp.home, arguments: {'role': role});
      return true;
    }
    return false;
  }

  /// ✅ Logout
  Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // remove all stored data

  // Clear states
  appVerificationState.clearTokens();

  // Move to Login Page
  Get.offAllNamed(RouteApp.login);
}

}
