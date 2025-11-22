import 'package:flutter/foundation.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _featuredBooks = [];
  List<Book> _recommendedBooks = [];
  List<Book> _userBooks = [];
  List<Book> _userDrafts = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => _books;
  List<Book> get featuredBooks => _featuredBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<Book> get userBooks => _userBooks;
  List<Book> get userDrafts => _userDrafts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setBooks(List<Book> books) {
    _books = books;
    _error = null;
    notifyListeners();
  }

  void setFeaturedBooks(List<Book> books) {
    _featuredBooks = books;
    _error = null;
    notifyListeners();
  }

  void setRecommendedBooks(List<Book> books) {
    _recommendedBooks = books;
    _error = null;
    notifyListeners();
  }

  void setUserBooks(List<Book> books) {
    _userBooks = books;
    _error = null;
    notifyListeners();
  }

  void setUserDrafts(List<Book> drafts) {
    _userDrafts = drafts;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  void removeBook(String bookId) {
    _books.removeWhere((book) => book.id == bookId);
    _userBooks.removeWhere((book) => book.id == bookId);
    _userDrafts.removeWhere((book) => book.id == bookId);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
