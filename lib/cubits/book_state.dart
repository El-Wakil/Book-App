import 'package:equatable/equatable.dart';
import '../models/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;
  final List<Book> mostViewedBooks;
  final List<String> categories;

  const BookLoaded({
    required this.books,
    required this.mostViewedBooks,
    required this.categories,
  });

  @override
  List<Object?> get props => [books, mostViewedBooks, categories];
}

class BookSearchLoaded extends BookState {
  final List<Book> searchResults;
  final String query;

  const BookSearchLoaded({required this.searchResults, required this.query});

  @override
  List<Object?> get props => [searchResults, query];
}

class BookCategoryLoaded extends BookState {
  final List<Book> categoryBooks;
  final String category;

  const BookCategoryLoaded({
    required this.categoryBooks,
    required this.category,
  });

  @override
  List<Object?> get props => [categoryBooks, category];
}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object?> get props => [message];
}
