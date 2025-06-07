import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  List<Booking> _bookings = [];
  String _selectedFilter = 'all';
  String _selectedSort = 'upcoming';

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _bookings = Booking.getSampleBookings();
      _applyFilterAndSort();
    });
  }

  void _applyFilterAndSort() {
    // Apply filter
    List<Booking> filteredBookings = _bookings.where((booking) {
      if (_selectedFilter == 'all') return true;
      return booking.status == _selectedFilter;
    }).toList();

    // Apply sort
    filteredBookings.sort((a, b) {
      if (_selectedSort == 'upcoming') {
        return a.checkInDate.compareTo(b.checkInDate);
      } else if (_selectedSort == 'amount') {
        return b.totalAmount.compareTo(a.totalAmount);
      } else {
        return b.checkInDate.compareTo(a.checkInDate);
      }
    });

    setState(() {
      _bookings = filteredBookings;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                      DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                        _applyFilterAndSort();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSort,
                    decoration: const InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                      DropdownMenuItem(value: 'amount', child: Text('Amount')),
                      DropdownMenuItem(value: 'recent', child: Text('Recent')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value!;
                        _applyFilterAndSort();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _bookings.isEmpty
                ? const Center(
                    child: Text(
                      'No bookings found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    booking.hotelName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(booking.status),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      booking.status.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Booking ID: ${booking.id}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Check-in',
                                      DateFormat('MMM dd, yyyy').format(booking.checkInDate),
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Check-out',
                                      DateFormat('MMM dd, yyyy').format(booking.checkOutDate),
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Guests',
                                      '${booking.numberOfGuests}',
                                      Icons.person,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Room Type',
                                      booking.roomType,
                                      Icons.king_bed,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Amount',
                                      '₹${booking.totalAmount.toStringAsFixed(2)}',
                                      Icons.currency_rupee,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                'Guest: ${booking.guestName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
} 