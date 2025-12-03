import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _userId;
  String? _bio;
  String? _location;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  String? get userId => _userId;
  String? get bio => _bio;
  String? get location => _location;

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
          bio: response['bio'],
          location: response['location'],
        );
        
        _userId = response['user_id'].toString();
        _username = response['username'] ?? email;
        _email = response['email'] ?? email;
        _bio = response['bio'];
        _location = response['location'];
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

  
  Future<bool> updateProfile({
    required String username,
    String? bio,
    String? location,
  }) async {
    try {
      if (_userId == null) return false;

      final response = await ApiService.patch(
        '/users/$_userId/',
        body: {
          'username': username,
          'bio': bio ?? '',
          'location': location ?? '',
        },
      );

      if (response != null) {
        _username = username;
        _bio = bio;
        _location = location;
        
        await StorageService.saveUserData(
          userId: _userId!,
          username: username,
          email: _email ?? '',
          bio: bio,
          location: location,
        );
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  Future<void> updateUsername(String newUsername) async {
    await updateProfile(username: newUsername, bio: _bio, location: _location);
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUserData();
    _isLoggedIn = false;
    _username = null;
    _email = null;
    _userId = null;
    _bio = null;
    _location = null;
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
      _bio = await StorageService.getBio();
      _location = await StorageService.getLocation();
    }
    
    notifyListeners();
  }
}
