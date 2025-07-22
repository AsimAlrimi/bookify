import 'dart:io';
import 'package:bookify/pages/booking_date_page.dart';
import 'package:bookify/services/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/models/book.dart';

class BookDetailsPage extends ConsumerWidget {
  final Book book;
  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    
    return Scaffold(

      appBar: AppBar(
        title: Text(book.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image Section
            Center(
              child: Hero(
                tag: 'book-${book.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildBookImage(isTablet),
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.04),
            
            // Title
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.01),
            
            // Author
            Text(
              'by ${book.author}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.02),
            
            // Rating
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: isTablet ? 28 : 24,
                ),
                SizedBox(width: isTablet ? 8 : 6),
                Text(
                  book.rating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: isTablet ? 8 : 6),
                Text(
                  '• Rating',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: screenHeight * 0.03),
            
            // Availability Status
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 10 : 8,
              ),
              decoration: BoxDecoration(
                color: book.available 
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: book.available 
                    ? Colors.green.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    book.available ? Icons.check_circle : Icons.cancel,
                    color: book.available ? Colors.green : Colors.red,
                    size: isTablet ? 20 : 18,
                  ),
                  SizedBox(width: isTablet ? 8 : 6),
                  Text(
                    book.available ? 'Available' : 'Not Available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: book.available ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: screenHeight * 0.04),
            
            // Description Section
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.015),
            
            Text(
              book.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.05),
            if (authState.role != 'admin') 
            // Rent Button
            SizedBox(
              width: double.infinity,
              height: isTablet ? 64 : 56,
              child: ElevatedButton(
                onPressed: book.available
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingDatePage(book: book),
                          ),
                        );
                      }
                    : null,
                    
                style: ElevatedButton.styleFrom(
                  elevation: book.available ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  book.available ? 'Rent This Book' : 'Not Available',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookImage(bool isTablet) {
    final size = isTablet ? 200.0 : 160.0;
    
    if (book.imagePath != null && book.imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(book.imagePath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Center(
          child: Text(
            book.title.isNotEmpty ? book.title[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: isTablet ? 48 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}