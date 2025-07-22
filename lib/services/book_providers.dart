import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_repository.dart';
import 'models/book.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) => BookRepository());

/// Holds the list of books (Async for future extension: network sync, etc.)
final booksProvider = StateNotifierProvider<BooksNotifier, AsyncValue<List<Book>>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return BooksNotifier(repo)..loadBooks();
});

class BooksNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  final BookRepository _repository;
  BooksNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadBooks() async {
    try {
      final list = await _repository.getAllBooks();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBook(Book book) async {
    try {
      await _repository.insertBook(book);
      await loadBooks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBook(Book book) async {
    if (book.id == null) return; // safety
    try {
      await _repository.updateBook(book);
      await loadBooks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      await _repository.deleteBook(id);
      await loadBooks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Optional: seed some sample books if DB is empty.
  Future<void> seedIfEmpty() async {
    final current = state.value;
    if (current != null && current.isEmpty) {
      await addBook(Book(title: 'Clean Code', author: 'Robert C. Martin', rating: 4.7, description: 'A handbook of agile software craftsmanship.'));
      await addBook(Book(title: 'The Pragmatic Programmer', author: 'Andrew Hunt', rating: 4.8, description: 'Journey to mastery in software development.'));
    }
  }
}