import 'package:flutter/material.dart';
import '../services/models/book.dart';
import 'booking_confirmation_page.dart';

class BookingDatePage extends StatefulWidget {
  final Book book;
  const BookingDatePage({Key? key, required this.book}) : super(key: key);

  @override
  State<BookingDatePage> createState() => _BookingDatePageState();
}

class _BookingDatePageState extends State<BookingDatePage> {
  DateTime? _startDate;
  DateTime? _endDate;
  
  String get _formattedStartDate => _startDate?.toString().split(' ')[0] ?? 'Select start date';
  String get _formattedEndDate => _endDate?.toString().split(' ')[0] ?? 'Select end date';
  bool get _canContinue => _startDate != null && _endDate != null;

  Future<void> _pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (date != null) {
      setState(() => isStart ? _startDate = date : _endDate = date);
    }
  }

  Widget _buildDateCard(String title, String subtitle, bool isStart) {
    return Card(
      child: InkWell(
        onTap: () => _pickDate(isStart),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Rental Dates'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Book Info Header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'By ${widget.book.author}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Date Selection
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your rental period',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDateCard('Start Date', _formattedStartDate, true),
                  const SizedBox(height: 16),
                  _buildDateCard('End Date', _formattedEndDate, false),
                ],
              ),
            ),
          ),
          
          // Continue Button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _canContinue ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingConfirmationPage(
                      book: widget.book,
                      startDate: _startDate!,
                      endDate: _endDate!,
                    ),
                  ),
                ) : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Continue to Confirmation'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}