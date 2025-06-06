import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';

class BookingService {
  static const String _baseUrl = 'https://crs.treebo.be/v1';
  final String phoneNumber = '7417386596'; // Hardcoded for testing

  Future<List<Booking>> fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bookings?guest_phone=$phoneNumber'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['data'] != null && data['data']['bookings'] != null) {
          final List<dynamic> bookingsJson = data['data']['bookings'];
          final bookings = bookingsJson
              .map((json) => Booking.fromJson(json))
              .toList();
          
          return _filterActiveBookings(bookings);
        }
      }
      
      throw Exception('Failed to load bookings');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  List<Booking> _filterActiveBookings(List<Booking> bookings) {
    final today = DateTime.now().toUtc();
    
    return bookings.where((booking) {
      // Check if status is one of the allowed statuses
      final validStatuses = {'reserved', 'checked_in', 'part_checked_in'};
      if (!validStatuses.contains(booking.status.toLowerCase())) {
        return false;
      }
      
      // Check if check-in date is valid and not in the past
      if (booking.checkInDate.isNotEmpty) {
        try {
          final checkInDate = DateTime.parse(booking.checkInDate.split('T')[0]);
          return checkInDate.isAfter(today.subtract(const Duration(days: 1)));
        } catch (e) {
          return false;
        }
      }
      
      return true; // If no check-in date but has valid status, still show it
    }).toList();
  }
}
