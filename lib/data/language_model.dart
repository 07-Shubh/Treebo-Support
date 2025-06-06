import 'package:flutter/material.dart';

class LanguageModel {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // Welcome message
      'welcome': 'Hello! I\'m your Treebo Assistant. How can I help you today?',
      
      // Check-in related
      'check_in': 'Check-in time is 2:00 PM. You can complete the check-in process at the front desk.',
      'check_out': 'Check-out time is 11:00 AM. Please ensure you have cleared your room by then.',
      
      // WiFi related
      'wifi': 'The WiFi password is "Treebo@123". The network name is "Treebo-Guest".',
      
      // Food related
      'breakfast': 'Breakfast is served from 7:00 AM to 10:00 AM in the hotel restaurant.',
      'room_service': 'Room service is available 24/7. You can order through the Treebo app or call the front desk.',
      
      // Amenities
      'amenities': 'We offer free WiFi, 24/7 room service, laundry service, and a fitness center. Would you like to know more about any specific amenity?',
      'parking': 'We offer complimentary parking for our guests. The parking area is located in the basement.',
      
      // Greetings
      'greeting': 'Hello! How can I assist you today?',
      'thanks': 'You\'re welcome! Is there anything else I can help you with?',
      'help': 'I can help you with check-in/check-out, WiFi, breakfast, room service, and other hotel services. What would you like to know?',
      'default': 'I\'m sorry, I don\'t understand. Could you please rephrase your question? You can ask me about check-in, check-out, WiFi, breakfast, or other hotel services.',
    },
    'hi': {
      // Welcome message
      'welcome': 'नमस्ते! मैं आपका Treebo Assistant हूं। मैं आपकी कैसे मदद कर सकता हूं?',
      
      // Check-in related
      'check_in': 'चेक-इन का समय दोपहर 2:00 बजे है। आप फ्रंट डेस्क पर चेक-इन प्रक्रिया पूरी कर सकते हैं।',
      'check_out': 'चेक-आउट का समय सुबह 11:00 बजे है। कृपया सुनिश्चित करें कि आपने अपना कमरा खाली कर दिया है।',
      
      // WiFi related
      'wifi': 'वाईफाई पासवर्ड "Treebo@123" है। नेटवर्क का नाम "Treebo-Guest" है।',
      
      // Food related
      'breakfast': 'नाश्ता सुबह 7:00 बजे से 10:00 बजे तक होटल के रेस्तरां में परोसा जाता है।',
      'room_service': 'रूम सर्विस 24/7 उपलब्ध है। आप Treebo ऐप के माध्यम से या फ्रंट डेस्क पर कॉल करके ऑर्डर कर सकते हैं।',
      
      // Amenities
      'amenities': 'हम मुफ्त वाईफाई, 24/7 रूम सर्विस, लॉन्ड्री सर्विस और फिटनेस सेंटर प्रदान करते हैं। क्या आप किसी विशेष सुविधा के बारे में और जानना चाहेंगे?',
      'parking': 'हम अपने मेहमानों के लिए मुफ्त पार्किंग प्रदान करते हैं। पार्किंग क्षेत्र बेसमेंट में स्थित है।',
      
      // Greetings
      'greeting': 'नमस्ते! मैं आपकी कैसे मदद कर सकता हूं?',
      'thanks': 'आपका स्वागत है! क्या मैं आपकी किसी और मदद कर सकता हूं?',
      'help': 'मैं चेक-इन/चेक-आउट, वाईफाई, नाश्ता, रूम सर्विस और अन्य होटल सेवाओं में आपकी मदद कर सकता हूं। आप क्या जानना चाहेंगे?',
      'default': 'मुझे खेद है, मैं समझ नहीं पाया। क्या आप कृपया अपना प्रश्न दोबारा पूछ सकते हैं? आप चेक-इन, चेक-आउट, वाईफाई, नाश्ता या अन्य होटल सेवाओं के बारे में पूछ सकते हैं।',
    },
  };

  static String getTranslation(String languageCode, String key) {
    return _translations[languageCode]?[key] ?? _translations['en']![key]!;
  }

  static String getResponse(String message, String languageCode) {
    message = message.toLowerCase();
    
    // Check-in related queries
    if (message.contains('check in') || message.contains('checkin') ||
        message.contains('चेक इन') || message.contains('चेक-इन')) {
      return getTranslation(languageCode, 'check_in');
    }
    
    // Check-out related queries
    if (message.contains('check out') || message.contains('checkout') ||
        message.contains('चेक आउट') || message.contains('चेक-आउट')) {
      return getTranslation(languageCode, 'check_out');
    }
    
    // WiFi related queries
    if (message.contains('wifi') || message.contains('password') || 
        message.contains('internet') || message.contains('वाईफाई')) {
      return getTranslation(languageCode, 'wifi');
    }
    
    // Breakfast related queries
    if (message.contains('breakfast') || message.contains('food') || 
        message.contains('meal') || message.contains('नाश्ता')) {
      return getTranslation(languageCode, 'breakfast');
    }
    
    // Room service queries
    if (message.contains('room service') || message.contains('food delivery') ||
        message.contains('रूम सर्विस')) {
      return getTranslation(languageCode, 'room_service');
    }
    
    // Amenities queries
    if (message.contains('amenities') || message.contains('facilities') ||
        message.contains('सुविधाएं')) {
      return getTranslation(languageCode, 'amenities');
    }
    
    // Parking queries
    if (message.contains('parking') || message.contains('car') ||
        message.contains('पार्किंग')) {
      return getTranslation(languageCode, 'parking');
    }
    
    // Greeting queries
    if (message.contains('hi') || message.contains('hello') || 
        message.contains('hey') || message.contains('नमस्ते')) {
      return getTranslation(languageCode, 'greeting');
    }
    
    // Thank you queries
    if (message.contains('thank') || message.contains('thanks') ||
        message.contains('धन्यवाद')) {
      return getTranslation(languageCode, 'thanks');
    }
    
    // Help queries
    if (message.contains('help') || message.contains('assist') ||
        message.contains('मदद')) {
      return getTranslation(languageCode, 'help');
    }
    
    // Default response
    return getTranslation(languageCode, 'default');
  }
} 