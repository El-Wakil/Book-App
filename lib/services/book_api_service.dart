import 'package:dio/dio.dart';
import '../models/book.dart';

class BookApiService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1';
  final Dio _dio;

  BookApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  // Get all books (computer science free ebooks)
  Future<List<Book>> getAllBooks() async {
    try {
      final response = await _dio.get(
        '/volumes',
        queryParameters: {
          'q': 'computer science',
          'filter': 'free-ebooks',
          'orderBy': 'newest',
          'maxResults': 40,
        },
      );

      final items = response.data['items'] as List<dynamic>? ?? [];
      return items.map((json) => Book.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch books: ${e.message}');
    }
  }

  // Get books by category
  Future<List<Book>> getBooksByCategory(String category) async {
    try {
      final response = await _dio.get(
        '/volumes',
        queryParameters: {
          'q': 'subject:$category',
          'filter': 'free-ebooks',
          'orderBy': 'newest',
          'maxResults': 40,
        },
      );

      final items = response.data['items'] as List<dynamic>? ?? [];
      return items.map((json) => Book.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch books by category: ${e.message}');
    }
  }

  // Search books by title or author
  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _dio.get(
        '/volumes',
        queryParameters: {
          'q': query,
          'filter': 'free-ebooks',
          'orderBy': 'relevance',
          'maxResults': 40,
        },
      );

      final items = response.data['items'] as List<dynamic>? ?? [];
      return items.map((json) => Book.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to search books: ${e.message}');
    }
  }

  // Get most viewed books (popular computer science books)
  Future<List<Book>> getMostViewedBooks() async {
    try {
      final response = await _dio.get(
        '/volumes',
        queryParameters: {
          'q': 'computer science programming',
          'filter': 'free-ebooks',
          'orderBy': 'relevance',
          'maxResults': 20,
        },
      );

      final items = response.data['items'] as List<dynamic>? ?? [];
      return items.map((json) => Book.fromJson(json)).take(10).toList();
    } catch (e) {
      throw Exception('Failed to fetch most viewed books: $e');
    }
  }

  // Get book categories (predefined popular categories)
  Future<List<String>> getCategories() async {
    try {
      // Return popular categories for free ebooks
      return [
        'Programming',
        'Computer Science',
        'Technology',
        'Science',
        'Mathematics',
        'Engineering',
        'Fiction',
        'History',
        'Philosophy',
        'Business',
      ];
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Get book by ID
  Future<Book?> getBookById(String id) async {
    try {
      final response = await _dio.get('/volumes/$id');
      return Book.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to fetch book: ${e.message}');
    }
  }
}
