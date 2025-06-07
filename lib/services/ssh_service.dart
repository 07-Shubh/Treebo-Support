import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BookingDetails {
  final String bookingId;
  final String referenceNumber;
  final String status;
  final String checkinDate;
  final String checkoutDate;
  final String guestName;
  final String phoneNumber;
  final String hotelId;
  final List<RoomStay> roomStays;

  BookingDetails({
    required this.bookingId,
    required this.referenceNumber,
    required this.status,
    required this.checkinDate,
    required this.checkoutDate,
    required this.guestName,
    required this.phoneNumber,
    required this.hotelId,
    required this.roomStays,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    final data = json['data']['bookings'][0];
    final customer = data['customers'].firstWhere(
      (c) => c['is_primary'] == true,
      orElse: () => data['customers'].first,
    );

    return BookingDetails(
      bookingId: data['booking_id'],
      referenceNumber: data['reference_number'],
      status: data['status'],
      checkinDate: data['checkin_date'],
      checkoutDate: data['checkout_date'],
      guestName: '${customer['first_name']} ${customer['last_name'] ?? ''}'.trim(),
      phoneNumber: '${customer['phone']['country_code']}${customer['phone']['number']}',
      hotelId: data['hotel_id'],
      roomStays: (data['room_stays'] as List)
          .map((room) => RoomStay.fromJson(room))
          .toList(),
    );
  }
}

class RoomStay {
  final String roomTypeId;
  final String status;
  final String checkinDate;
  final String checkoutDate;
  final List<GuestStay> guestStays;

  RoomStay({
    required this.roomTypeId,
    required this.status,
    required this.checkinDate,
    required this.checkoutDate,
    required this.guestStays,
  });

  factory RoomStay.fromJson(Map<String, dynamic> json) {
    return RoomStay(
      roomTypeId: json['room_type_id'],
      status: json['status'],
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      guestStays: (json['guest_stays'] as List)
          .map((guest) => GuestStay.fromJson(guest))
          .toList(),
    );
  }
}

class GuestStay {
  final String status;
  final String checkinDate;
  final String checkoutDate;
  final String ageGroup;

  GuestStay({
    required this.status,
    required this.checkinDate,
    required this.checkoutDate,
    required this.ageGroup,
  });

  factory GuestStay.fromJson(Map<String, dynamic> json) {
    return GuestStay(
      status: json['status'],
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      ageGroup: json['age_group'],
    );
  }
}

class SshService {
  static const String _baseUrl = 'http://localhost:8000/api';

  static Future<BookingDetails> getBookingDetails(String phoneNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/booking/$phoneNumber'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return BookingDetails.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load booking: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to connect to the server. Make sure the Python server is running: $e');
    } on FormatException catch (e) {
      throw Exception('Failed to parse API response: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
