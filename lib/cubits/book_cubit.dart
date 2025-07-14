import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/book_api_service.dart';
import 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookApiService _apiService;

  BookCubit(this._apiService) : super(BookInitial());

  Future<void> loadBooks() async {
    try {
      emit(BookLoading());

      final books = await _apiService.getAllBooks();
      final mostViewedBooks = await _apiService.getMostViewedBooks();
      final categories = await _apiService.getCategories();

      emit(
        BookLoaded(
          books: books,
          mostViewedBooks: mostViewedBooks,
          categories: categories,
        ),
      );
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      loadBooks();
      return;
    }

    try {
      emit(BookLoading());
      final searchResults = await _apiService.searchBooks(query);
      emit(BookSearchLoaded(searchResults: searchResults, query: query));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> loadBooksByCategory(String category) async {
    try {
      emit(BookLoading());
      final categoryBooks = await _apiService.getBooksByCategory(category);
      emit(
        BookCategoryLoaded(categoryBooks: categoryBooks, category: category),
      );
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  void resetToHome() {
    loadBooks();
  }
}
