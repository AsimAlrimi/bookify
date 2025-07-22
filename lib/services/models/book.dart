class Book {
  final int? id;
  final String title;
  final String author;
  final double rating;
  final String description;
  final bool available;
  final String? imagePath; 

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.description,
    this.available = true,
    this.imagePath,
  });

  // Convert Book object to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rating': rating,
      'description': description,
      'available': available ? 1 : 0,
      'imagePath': imagePath,
    };
  }

  // Create Book object from Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      rating: map['rating'],
      description: map['description'],
      available: map['available'] == 1,
      imagePath: map['imagePath'],
    );
  }
}