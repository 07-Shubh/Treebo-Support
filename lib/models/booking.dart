class Booking {
  final String bookingId;
  final String referenceNumber;
  final String checkInDate;
  final String checkOutDate;
  final String status;
  final String hotelId;
  final List<Customer> customers;
  final List<RoomStay> roomStays;

  Booking({
    required this.bookingId,
    required this.referenceNumber,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.hotelId,
    required this.customers,
    required this.roomStays,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'] ?? '',
      referenceNumber: json['reference_number'] ?? '',
      checkInDate: json['checkin_date'] ?? '',
      checkOutDate: json['checkout_date'] ?? '',
      status: json['status'] ?? '',
      hotelId: json['hotel_id'] ?? '',
      customers: (json['customers'] as List<dynamic>?)
              ?.map((customer) => Customer.fromJson(customer))
              .toList() ??
          [],
      roomStays: (json['room_stays'] as List<dynamic>?)
              ?.map((roomStay) => RoomStay.fromJson(roomStay))
              .toList() ??
          [],
    );
  }
}

class Customer {
  final String customerId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final Phone? phone;
  final bool isPrimary;

  Customer({
    required this.customerId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    required this.isPrimary,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'] != null ? Phone.fromJson(json['phone']) : null,
      isPrimary: json['is_primary'] ?? false,
    );
  }
}

class Phone {
  final String countryCode;
  final String number;

  Phone({required this.countryCode, required this.number});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      countryCode: json['country_code'] ?? '',
      number: json['number'] ?? '',
    );
  }
}

class RoomStay {
  final String roomStayId;
  final String roomTypeId;
  final String status;
  final String stayStart;
  final String stayEnd;

  RoomStay({
    required this.roomStayId,
    required this.roomTypeId,
    required this.status,
    required this.stayStart,
    required this.stayEnd,
  });

  factory RoomStay.fromJson(Map<String, dynamic> json) {
    return RoomStay(
      roomStayId: json['room_stay_id'].toString(),
      roomTypeId: json['room_type_id'] ?? '',
      status: json['status'] ?? '',
      stayStart: json['stay_start'] ?? '',
      stayEnd: json['stay_end'] ?? '',
    );
  }
}
