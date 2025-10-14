import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppVerificationState extends GetxController {
  final GetStorage _storage = GetStorage();
  
  String _accessToken = "";
  String _refreshToken = "";
  Map<String, dynamic> _user = {};

  // Initialize authentication state
  Future<void> initialize() async {
    _accessToken = _storage.read("accessToken") ?? "";
    _refreshToken = _storage.read("refreshToken") ?? "";
    _user = _storage.read("user") ?? {};
    update();
  }

  // Set both tokens after successful login
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    Map<String, dynamic>? user,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    if (user != null) _user = user;
    
    await Future.wait([
      _storage.write("accessToken", accessToken),
      _storage.write("refreshToken", refreshToken),
      if (user != null) _storage.write("user", user),
    ]);
    
    update();
  }

  // Clear all authentication data
  Future<void> clearAll() async {
    _accessToken = "";
    _refreshToken = "";
    _user = {};
    
    await Future.wait([
      _storage.remove("accessToken"),
      _storage.remove("refreshToken"),
      _storage.remove("user"),
    ]);
    
    update();
  }

  // Getters
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  Map<String, dynamic> get user => _user;
  
  // Convenience getters
  bool get isAuthenticated => _accessToken.isNotEmpty;
  String? get username => _user['username'];
  String? get userId => _user['id']?.toString();
  String? get userRole => _user['role'];
}