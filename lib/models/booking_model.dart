class Booking {
  final String id;
  final String hotelName;
  final String roomType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final double totalAmount;
  final String status; // 'confirmed', 'cancelled', 'completed'
  final String bookingDate;
  final String guestName;
  final String guestEmail;
  final String guestPhone;

  Booking({
    required this.id,
    required this.hotelName,
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalAmount,
    required this.status,
    required this.bookingDate,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
  });

  // Sample data for testing
  static List<Booking> getSampleBookings() {
    return [
      Booking(
        id: 'WLK-0016581-4VC2PF',
        hotelName: 'Treebo Club Worldtree Staging',
        roomType: 'Deluxe Room',
        checkInDate: DateTime.now().add(const Duration(days: 2)),
        checkOutDate: DateTime.now().add(const Duration(days: 4)),
        numberOfGuests: 2,
        totalAmount: 5999.0,
        status: 'confirmed',
        bookingDate: DateTime.now().toString(),
        guestName: 'Venkata',
        guestEmail: 'john@example.com',
        guestPhone: '+91 9876543210',
      ),
      Booking(
        id: 'WLK-0016581-I71ZA8',
        hotelName: 'Treebo Club Worldtree Staging',
        roomType: 'Executive Suite',
        checkInDate: DateTime.now().add(const Duration(days: 5)),
        checkOutDate: DateTime.now().add(const Duration(days: 7)),
        numberOfGuests: 3,
        totalAmount: 8999.0,
        status: 'confirmed',
        bookingDate: DateTime.now().toString(),
        guestName: 'Venkata',
        guestEmail: 'jane@example.com',
        guestPhone: '+91 9876543211',
      ),
      
    ];
  }
} 