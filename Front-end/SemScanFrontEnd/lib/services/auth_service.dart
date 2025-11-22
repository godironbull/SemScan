import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      return {
        'user': User.fromJson(response['user']),
        'token': response['token'],
      };
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      return {
        'user': User.fromJson(response['user']),
        'token': response['token'],
      };
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Forgot Password
  static Future<void> forgotPassword(String email) async {
    try {
      await ApiService.post(
        '/auth/forgot-password',
        body: {'email': email},
      );
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await ApiService.post('/auth/logout');
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
