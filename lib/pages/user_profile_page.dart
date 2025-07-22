import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_order_providers.dart';

class UserProfilePage extends ConsumerWidget {
  final String userEmail;
  const UserProfilePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider(userEmail));
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
         'My Profile & Rentals',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
            ),
           ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 50 : 40,
                    backgroundColor: Colors.grey[800],
                    child: Icon(
                      Icons.person_rounded,
                      size: isTablet ? 60 : 48,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    userEmail,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),

            // Rentals Section
            Expanded(
              child: ordersAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: isTablet ? 80 : 64,
                           
                          ),
                          SizedBox(height: isTablet ? 24 : 16),
                          Text(
                            'No rental history yet',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            'Start renting books to see them here',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : 16,
                      vertical: 8,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final status = order['status'];
                      
                      Color statusColor = status == 'approved' ? Colors.green :
                                         status == 'returned' ? Colors.blue : 
                                         Colors.orange;
                      
                      IconData statusIcon = status == 'approved' ? Icons.check_circle :
                                           status == 'returned' ? Icons.done_all :
                                           Icons.hourglass_bottom;

                      return Container(
                        margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 20 : 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order['bookTitle'],
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.titleLarge?.color,
                                        fontSize: isTablet ? 18 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 12 : 8),
                                    
                                    // Status
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: statusColor.withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            status.toUpperCase(),
                                            style: TextStyle(
                                              color: statusColor,
                                              fontSize: isTablet ? 12 : 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: isTablet ? 12 : 8),
                                    
                                    // Date Range
                                    Text(
                                      '${order['startDate'].toString().substring(0, 10)} → ${order['endDate'].toString().substring(0, 10)}',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              Icon(
                                statusIcon,
                                color: statusColor,
                                size: isTablet ? 32 : 24,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: isTablet ? 64 : 48,
                        color: Colors.red[400],
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        'Please try again later',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isTablet ? 14 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}