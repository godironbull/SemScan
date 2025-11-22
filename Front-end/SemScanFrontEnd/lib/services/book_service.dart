import '../models/book.dart';
import 'api_service.dart';

class BookService {
  // Get all books
  static Future<List<Book>> getAllBooks() async {
    try {
      final response = await ApiService.get('/books');
      return (response as List).map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  // Search books
  static Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await ApiService.get('/books/search?q=$query');
      return (response as List).map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  // Get book by ID
  static Future<Book> getBookById(String id) async {
    try {
      final response = await ApiService.get('/books/$id');
      return Book.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load book: $e');
    }
  }

  // Get user's books
  static Future<List<Book>> getUserBooks(String userId) async {
    try {
      final response = await ApiService.get('/users/$userId/books');
      return (response as List).map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load user books: $e');
    }
  }

  // Get user's drafts
  static Future<List<Book>> getUserDrafts(String userId) async {
    try {
      final response = await ApiService.get('/users/$userId/drafts');
      return (response as List).map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load drafts: $e');
    }
  }

  // Create book
  static Future<Book> createBook(Map<String, dynamic> bookData) async {
    try {
      final response = await ApiService.post('/books', body: bookData);
      return Book.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create book: $e');
    }
  }

  // Update book
  static Future<Book> updateBook(String id, Map<String, dynamic> bookData) async {
    try {
      final response = await ApiService.put('/books/$id', body: bookData);
      return Book.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  // Delete book
  static Future<void> deleteBook(String id) async {
    try {
      await ApiService.delete('/books/$id');
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // Get featured books
  static Future<List<Book>> getFeaturedBooks() async {
    try {
      final response = await ApiService.get('/books/featured');
      return (response as List).map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load featured books: $e');
    }
  }

  // Get recommended books
  static Future<List<Book>> getRecommendedBooks() async {
    try {
      final response = await ApiService.get('/books/recommended');
      return (response as List).map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load recommended books: $e');
    }
  }
}
