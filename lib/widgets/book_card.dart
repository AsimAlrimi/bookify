import 'dart:io';
import 'package:flutter/material.dart';
import '../services/models/book.dart';
import '../pages/book_details_page.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BookDetailsPage(book: book),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: Hero(
            tag: 'book-${book.id}',
            child: _buildBookImage(),
          ),
          title: Text(book.title),
          subtitle: Text('${book.author} • ${book.rating.toStringAsFixed(1)} ★'),
          trailing: Icon(
            book.available ? Icons.book : Icons.lock,
            color: book.available ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    if (book.imagePath != null && book.imagePath!.isNotEmpty) {
      return ClipOval(
        child: Image.file(
          File(book.imagePath!),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(
          book.title.isNotEmpty ? book.title[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
