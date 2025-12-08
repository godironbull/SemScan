import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  // TODO: Replace with your actual Django backend URL
  // Example: 'http://localhost:8000/api' or 'http://YOUR_IP:8000/api'
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Timeout duration for requests
  static const Duration timeout = Duration(seconds: 30);

  // Base headers for requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get headers with authentication token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await StorageService.getToken();
    if (token != null) {
      return {
        ..._headers,
        'Authorization': 'Token $token', // Django Token format
      };
    }
    return _headers;
  }

  // GET request
  static Future<dynamic> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = requiresAuth ? await _getAuthHeaders() : _headers;
      
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth ? await _getAuthHeaders() : _headers;
      
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth ? await _getAuthHeaders() : _headers;
      
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  static Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth ? await _getAuthHeaders() : _headers;
      
      final response = await http
          .patch(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  static Future<dynamic> delete(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = requiresAuth ? await _getAuthHeaders() : _headers;
      
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle HTTP response
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        // Try to parse error message from response
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map) {
            // Try different possible error keys
            if (errorBody.containsKey('error')) {
              throw Exception(errorBody['error']);
            } else if (errorBody.containsKey('msg')) {
              throw Exception(errorBody['msg']);
            } else if (errorBody.containsKey('message')) {
              throw Exception(errorBody['message']);
            } else if (errorBody.containsKey('detail')) {
              throw Exception(errorBody['detail']);
            } else if (errorBody.isNotEmpty) {
              // If there are other keys, try to get the first value
              final firstKey = errorBody.keys.first;
              final firstValue = errorBody[firstKey];
              if (firstValue is String) {
                throw Exception(firstValue);
              } else if (firstValue is List && firstValue.isNotEmpty) {
                throw Exception(firstValue[0].toString());
              }
            }
          }
        } catch (e) {
          // If it's already an Exception with a message, rethrow it
          if (e is Exception) {
            rethrow;
          }
          // If parsing fails, use default message
        }
        throw Exception('Requisição inválida. Verifique os dados.');
      case 401:
        throw Exception('Não autorizado. Faça login novamente.');
      case 403:
        throw Exception('Acesso negado.');
      case 404:
        throw Exception('Recurso não encontrado.');
      case 500:
        throw Exception('Erro no servidor. Tente novamente mais tarde.');
      default:
        throw Exception('Erro desconhecido (${response.statusCode})');
    }
  }

  // Handle errors
  static Exception _handleError(dynamic error) {
    if (error is Exception) return error;
    return Exception('Network error: $error');
  }
}
