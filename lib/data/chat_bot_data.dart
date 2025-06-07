class ChatBotData {
  static const String welcomeMessage = 'Hello! I\'m your Treebo Assistant. How can I help you today?';

  static String getResponse(String message) {
    message = message.toLowerCase();
    
    // Check-in related queries
    if (message.contains('check in') || message.contains('checkin')) {
      return 'Check-in time is 2:00 PM. You can complete the check-in process at the front desk.';
    }
    
    // Check-out related queries
    if (message.contains('check out') || message.contains('checkout')) {
      return 'Check-out time is 11:00 AM. Please ensure you have cleared your room by then.';
    }
    
    // WiFi related queries
    if (message.contains('wifi') || message.contains('password') || message.contains('internet')) {
      return 'The WiFi password is "Treebo@123". The network name is "Treebo-Guest".';
    }
    
    // Breakfast related queries
    if (message.contains('breakfast') || message.contains('food') || message.contains('meal')) {
      return 'Breakfast is served from 7:00 AM to 10:00 AM in the hotel restaurant.';
    }
    
    // Room service queries
    if (message.contains('room service') || message.contains('food delivery')) {
      return 'Room service is available 24/7. You can order through the Treebo app or call the front desk.';
    }
    
    // Amenities queries
    if (message.contains('amenities') || message.contains('facilities')) {
      return 'We offer free WiFi, 24/7 room service, laundry service, and a fitness center. Would you like to know more about any specific amenity?';
    }
    
    // Parking queries
    if (message.contains('parking') || message.contains('car')) {
      return 'We offer complimentary parking for our guests. The parking area is located in the basement.';
    }
    
    // Greeting queries
    if (message.contains('hi') || message.contains('hello') || message.contains('hey')) {
      return 'Hello! How can I assist you today?';
    }
    
    // Thank you queries
    if (message.contains('thank') || message.contains('thanks')) {
      return 'You\'re welcome! Is there anything else I can help you with?';
    }
    
    // Help queries
    if (message.contains('help') || message.contains('assist')) {
      return 'I can help you with check-in/check-out, WiFi, breakfast, room service, and other hotel services. What would you like to know?';
    }
    
    // Default response for unrecognized queries
    return 'I\'m sorry, I don\'t understand. Could you please rephrase your question? You can ask me about check-in, check-out, WiFi, breakfast, or other hotel services.';
  }
} 