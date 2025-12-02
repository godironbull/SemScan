import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  String? get userId => _userId;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.post(
        '/users/login/',
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response != null && response['token'] != null) {
        await StorageService.saveToken(response['token']);
        
        // Save user data
        await StorageService.saveUserData(
          userId: response['user_id'].toString(),
          username: response['username'] ?? email,
          email: response['email'] ?? email,
        );
        
        _userId = response['user_id'].toString();
        _username = response['username'] ?? email;
        _email = response['email'] ?? email;
        _isLoggedIn = true;
        notifyListeners();
        return {'success': true};
      }
      return {'success': false, 'error': 'Erro ao processar resposta do servidor'};
    } catch (e) {
      debugPrint('Login error: $e');
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      return {'success': false, 'error': errorMsg};
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await ApiService.post(
        '/users/register/',
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response != null && response['token'] != null) {
        await StorageService.saveToken(response['token']);
        
        // Save user data
        await StorageService.saveUserData(
          userId: response['user_id'].toString(),
          username: response['username'] ?? username,
          email: response['email'] ?? email,
        );
        
        _userId = response['user_id'].toString();
        _username = response['username'] ?? username;
        _email = response['email'] ?? email;
        _isLoggedIn = true;
        notifyListeners();
        return {'success': true};
      }
      return {'success': false, 'error': 'Erro ao processar resposta do servidor'};
    } catch (e) {
      debugPrint('Register error: $e');
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      return {'success': false, 'error': errorMsg};
    }
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUserData();
    _isLoggedIn = false;
    _username = null;
    _email = null;
    _userId = null;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final token = await StorageService.getToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    
    if (_isLoggedIn) {
      // Load user data
      _userId = await StorageService.getUserId();
      _username = await StorageService.getUsername();
      _email = await StorageService.getEmail();
    }
    
    notifyListeners();
  }
}
