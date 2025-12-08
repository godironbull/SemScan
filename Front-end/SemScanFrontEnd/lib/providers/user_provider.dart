import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _userId;
  String? _name;
  String? _bio;
  String? _location;
  String? _profilePicturePath;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  String? get userId => _userId;
  String? get name => _name;
  String? get bio => _bio;
  String? get location => _location;
  String? get profilePicturePath => _profilePicturePath;

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
          name: response['name'] ?? response['username'] ?? email,
          bio: response['bio'],
          location: response['location'],
        );
        
        _userId = response['user_id'].toString();
        _username = response['username'] ?? email;
        _email = response['email'] ?? email;
        _name = response['name'] ?? response['username'] ?? email;
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
          name: response['name'] ?? username,
        );
        
        _userId = response['user_id'].toString();
        _username = response['username'] ?? username;
        _email = response['email'] ?? email;
        _name = response['name'] ?? username;
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
    required String name,
    String? bio,
    String? location,
  }) async {
    try {
      if (_userId == null) return false;

      final response = await ApiService.patch(
        '/users/$_userId/',
        body: {
          'name': name,
          'bio': bio ?? '',
          'location': location ?? '',
        },
        requiresAuth: true,
      );

      if (response != null) {
        _name = name;
        _bio = bio;
        _location = location;
        
        await StorageService.saveUserData(
          userId: _userId!,
          username: _username ?? _email ?? '',
          email: _email ?? '',
          name: name,
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

  Future<void> updateUsername(String newName) async {
    await updateProfile(name: newName, bio: _bio, location: _location);
  }

  // Set profile picture
  Future<void> setProfilePicture(String path) async {
    _profilePicturePath = path;
    await StorageService.saveProfilePicturePath(path);
    notifyListeners();
  }

  // Clear profile picture
  Future<void> clearProfilePicture() async {
    _profilePicturePath = null;
    await StorageService.removeProfilePicture();
    notifyListeners();
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUserData();
    await StorageService.removeProfilePicture();
    _isLoggedIn = false;
    _username = null;
    _email = null;
    _userId = null;
    _name = null;
    _bio = null;
    _location = null;
    _profilePicturePath = null;
    notifyListeners();
  }

  // Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      if (_userId == null) {
        return {'success': false, 'error': 'Usuário não identificado'};
      }

      final response = await ApiService.delete(
        '/users/$_userId/',
        requiresAuth: true,
      );

      // Clear local data after successful deletion
      await StorageService.removeToken();
      await StorageService.removeUserData();
      await StorageService.removeProfilePicture();
      _isLoggedIn = false;
      _username = null;
      _email = null;
      _userId = null;
      _name = null;
      _bio = null;
      _location = null;
      _profilePicturePath = null;
      notifyListeners();

      return {'success': true};
    } catch (e) {
      debugPrint('Delete account error: $e');
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      return {'success': false, 'error': errorMsg};
    }
  }

  Future<void> checkLoginStatus() async {
    final token = await StorageService.getToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    
    if (_isLoggedIn) {
      // Load user data
      _userId = await StorageService.getUserId();
      _username = await StorageService.getUsername();
      _email = await StorageService.getEmail();
      _name = await StorageService.getName();
      _bio = await StorageService.getBio();
      _location = await StorageService.getLocation();
      _profilePicturePath = await StorageService.getProfilePicturePath();
    }
    
    notifyListeners();
  }
}
