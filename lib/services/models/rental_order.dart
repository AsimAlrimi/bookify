class RentalOrder {
  final int? id;
  final int bookId;
  final String userEmail;
  final String startDate;
  final String endDate;
  final String status; // pending, approved, returned

  RentalOrder({
    this.id,
    required this.bookId,
    required this.userEmail,
    required this.startDate,
    required this.endDate,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'userEmail': userEmail,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  factory RentalOrder.fromMap(Map<String, dynamic> map) {
    return RentalOrder(
      id: map['id'],
      bookId: map['bookId'],
      userEmail: map['userEmail'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      status: map['status'],
    );
  }
}