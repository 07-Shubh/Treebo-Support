import 'package:flutter/material.dart';

class LanguageModel {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // Welcome message
      'welcome': 'Welcome to Treebo Support! How can I help you today?',
      
      // Check-in related
      'check_in': 'Check-in time is from 12:00 PM onwards. Please bring a valid government ID and the credit card used for booking.',
      'check_out': 'Check-out time is until 11:00 AM. You can request a late check-out subject to availability.',
      
      // WiFi related
      'wifi': 'The WiFi password is "TreeboGuest2024". The network name is "Treebo-Hotel".',
      
      // Food related
      'breakfast': 'Breakfast is served from 7:00 AM to 10:00 AM in the hotel restaurant.',
      'room_service': 'Room service is available 24/7. You can order through the Treebo app or call the front desk.',
      
      // Amenities
      'amenities': 'We provide complimentary toiletries, towels, and basic amenities. Additional items can be requested from housekeeping.',
      'parking': 'Complimentary parking is available for hotel guests. Please collect the parking pass from the front desk.',
      
      // Greetings
      'greeting': 'Hello! How can I assist you today?',
      'thanks': 'You\'re welcome! Is there anything else I can help you with?',
      'help': 'I can help you with check-in/check-out times, WiFi, breakfast, room service, amenities, and parking information.',
      'default': "I'm not sure I understand. Could you please rephrase your question?",
    },
    'hi': {
      // Welcome message
      'welcome': 'ट्रीबो सपोर्ट में आपका स्वागत है! मैं आपकी कैसे मदद कर सकता हूं?',
      
      // Check-in related
      'check_in': 'चेक-इन का समय दोपहर 12:00 बजे से है। कृपया वैध सरकारी आईडी और बुकिंग के लिए उपयोग किया गया क्रेडिट कार्ड लाएं।',
      'check_out': 'चेक-आउट का समय सुबह 11:00 बजे तक है। उपलब्धता के आधार पर लेट चेक-आउट का अनुरोध कर सकते हैं।',
      
      // WiFi related
      'wifi': 'वाईफाई पासवर्ड "TreeboGuest2024" है। नेटवर्क का नाम "Treebo-Hotel" है।',
      
      // Food related
      'breakfast': 'नाश्ता सुबह 7:00 बजे से 10:00 बजे तक होटल के रेस्तरां में परोसा जाता है।',
      'room_service': 'रूम सर्विस 24/7 उपलब्ध है। आप ट्रीबो ऐप के माध्यम से या फ्रंट डेस्क पर कॉल करके ऑर्डर कर सकते हैं।',
      
      // Amenities
      'amenities': 'हम मुफ्त टॉयलेटरीज, तौलिए और बुनियादी सुविधाएं प्रदान करते हैं। अतिरिक्त वस्तुओं के लिए हाउसकीपिंग से अनुरोध कर सकते हैं।',
      'parking': 'होटल के मेहमानों के लिए मुफ्त पार्किंग उपलब्ध है। कृपया फ्रंट डेस्क से पार्किंग पास लें।',
      
      // Greetings
      'greeting': 'नमस्ते! मैं आपकी कैसे मदद कर सकता हूं?',
      'thanks': 'आपका स्वागत है! क्या मैं आपकी किसी और मदद कर सकता हूं?',
      'help': 'मैं आपकी चेक-इन/चेक-आउट टाइम, वाईफाई, नाश्ता, रूम सर्विस, सुविधाएं और पार्किंग की जानकारी में मदद कर सकता हूं।',
      'default': 'मुझे आपका प्रश्न समझ नहीं आया। कृपया अपना प्रश्न दोबारा पूछें।',
    },
    'te': {
      'welcome': 'ట్రీబో సపోర్ట్‌కి స్వాగతం! నేను మీకు ఎలా సహాయం చేయగలను?',
      'check_in': 'చెక్-ఇన్ సమయం మధ్యాహ్నం 12:00 గంటల నుండి. దయచేసి చెల్లుబాటు అయ్యే ప్రభుత్వ ఐడి మరియు బుకింగ్ కోసం ఉపయోగించిన క్రెడిట్ కార్డ్ తీసుకురండి.',
      'check_out': 'చెక్-అవుట్ సమయం ఉదయం 11:00 గంటల వరకు. లభ్యత ఆధారంగా లేట్ చెక్-అవుట్ అభ్యర్థించవచ్చు.',
      'wifi': 'వైఫై పాస్‌వర్డ్ "TreeboGuest2024". నెట్‌వర్క్ పేరు "Treebo-Hotel".',
      'breakfast': 'ఉపాహారం ఉదయం 7:00 గంటల నుండి 10:00 గంటల వరకు హోటల్ రెస్టారెంట్‌లో సర్వ్ చేయబడుతుంది.',
      'room_service': 'రూమ్ సర్వీస్ 24/7 అందుబాటులో ఉంది. మీరు ట్రీబో యాప్ ద్వారా లేదా ఫ్రంట్ డెస్క్‌కు కాల్ చేసి ఆర్డర్ చేయవచ్చు.',
      'amenities': 'మేము ఉచిత టాయిలెట్రీస్, టవల్స్ మరియు ప్రాథమిక సౌకర్యాలను అందిస్తాము. అదనపు వస్తువుల కోసం హౌస్‌కీపింగ్‌ని అభ్యర్థించవచ్చు.',
      'parking': 'హోటల్ అతిథులకు ఉచిత పార్కింగ్ అందుబాటులో ఉంది. దయచేసి ఫ్రంట్ డెస్క్‌నుండి పార్కింగ్ పాస్ సేకరించండి.',
      'greeting': 'నమస్కారం! నేను మీకు ఎలా సహాయం చేయగలను?',
      'help': 'నేను మీకు చెక్-ఇన్/చెక్-అవుట్ సమయాలు, వైఫై, ఉపాహారం, రూమ్ సర్వీస్, సౌకర్యాలు మరియు పార్కింగ్ సమాచారంలో సహాయం చేయగలను.',
      'default': 'మీ ప్రశ్నను అర్థం చేసుకోలేకపోయాను. దయచేసి మీ ప్రశ్నను మళ్లీ అడగండి.',
    }
  };

  static String getTranslation(String languageCode, String key) {
    return _translations[languageCode]?[key] ?? _translations['en']![key]!;
  }

  static String detectLanguage(String message) {
    // Check for Hindi characters
    if (RegExp(r'[\u0900-\u097F]').hasMatch(message)) {
      return 'hi';
    }
    // Check for Telugu characters
    if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(message)) {
      return 'te';
    }
    // Default to English
    return 'en';
  }

  static String getResponse(String message) {
    final languageCode = detectLanguage(message);
    final lowerMessage = message.toLowerCase();

    // Hindi keywords
    if (languageCode == 'hi') {
      if (lowerMessage.contains('चेक-इन') || 
          lowerMessage.contains('चेक इन') || 
          lowerMessage.contains('चेकिन')) {
        return getTranslation('hi', 'check_in');
      }
      if (lowerMessage.contains('चेक-आउट') || 
          lowerMessage.contains('चेक आउट') || 
          lowerMessage.contains('चेकआउट')) {
        return getTranslation('hi', 'check_out');
      }
      if (lowerMessage.contains('वाईफाई') || 
          lowerMessage.contains('इंटरनेट') || 
          lowerMessage.contains('पासवर्ड')) {
        return getTranslation('hi', 'wifi');
      }
      if (lowerMessage.contains('नाश्ता') || 
          lowerMessage.contains('खाना') || 
          lowerMessage.contains('भोजन')) {
        return getTranslation('hi', 'breakfast');
      }
      if (lowerMessage.contains('रूम सर्विस') || 
          lowerMessage.contains('खाना मंगवाना')) {
        return getTranslation('hi', 'room_service');
      }
      if (lowerMessage.contains('सुविधाएं') || 
          lowerMessage.contains('सेवाएं')) {
        return getTranslation('hi', 'amenities');
      }
      if (lowerMessage.contains('पार्किंग') || 
          lowerMessage.contains('गाड़ी')) {
        return getTranslation('hi', 'parking');
      }
      if (lowerMessage.contains('नमस्ते') || 
          lowerMessage.contains('हैलो') || 
          lowerMessage.contains('हाय')) {
        return getTranslation('hi', 'greeting');
      }
      if (lowerMessage.contains('मदद') || 
          lowerMessage.contains('सहायता')) {
        return getTranslation('hi', 'help');
      }
    }
    // Telugu keywords
    else if (languageCode == 'te') {
      if (lowerMessage.contains('చెక్-ఇన్') || 
          lowerMessage.contains('చెక్ ఇన్')) {
        return getTranslation('te', 'check_in');
      }
      if (lowerMessage.contains('చెక్-అవుట్') || 
          lowerMessage.contains('చెక్ అవుట్')) {
        return getTranslation('te', 'check_out');
      }
      if (lowerMessage.contains('వైఫై') || 
          lowerMessage.contains('ఇంటర్నెట్') || 
          lowerMessage.contains('పాస్‌వర్డ్')) {
        return getTranslation('te', 'wifi');
      }
      if (lowerMessage.contains('ఉపాహారం') || 
          lowerMessage.contains('ఆహారం') || 
          lowerMessage.contains('భోజనం')) {
        return getTranslation('te', 'breakfast');
      }
      if (lowerMessage.contains('రూమ్ సర్వీస్') || 
          lowerMessage.contains('ఆహారం తెచ్చుకోవడం')) {
        return getTranslation('te', 'room_service');
      }
      if (lowerMessage.contains('సౌకర్యాలు') || 
          lowerMessage.contains('సేవలు')) {
        return getTranslation('te', 'amenities');
      }
      if (lowerMessage.contains('పార్కింగ్') || 
          lowerMessage.contains('కారు')) {
        return getTranslation('te', 'parking');
      }
      if (lowerMessage.contains('నమస్కారం') || 
          lowerMessage.contains('హలో') || 
          lowerMessage.contains('హాయ్')) {
        return getTranslation('te', 'greeting');
      }
      if (lowerMessage.contains('సహాయం') || 
          lowerMessage.contains('ఎలా')) {
        return getTranslation('te', 'help');
      }
    }
    // English keywords
    else {
      if (lowerMessage.contains('check-in') || 
          lowerMessage.contains('checkin') || 
          lowerMessage.contains('check in')) {
        return getTranslation('en', 'check_in');
      }
      if (lowerMessage.contains('check-out') || 
          lowerMessage.contains('checkout') || 
          lowerMessage.contains('check out')) {
        return getTranslation('en', 'check_out');
      }
      if (lowerMessage.contains('wifi') || 
          lowerMessage.contains('wi-fi') || 
          lowerMessage.contains('internet')) {
        return getTranslation('en', 'wifi');
      }
      if (lowerMessage.contains('breakfast') || 
          lowerMessage.contains('food') || 
          lowerMessage.contains('meal')) {
        return getTranslation('en', 'breakfast');
      }
      if (lowerMessage.contains('room service') || 
          lowerMessage.contains('food delivery')) {
        return getTranslation('en', 'room_service');
      }
      if (lowerMessage.contains('amenities') || 
          lowerMessage.contains('facilities') || 
          lowerMessage.contains('services')) {
        return getTranslation('en', 'amenities');
      }
      if (lowerMessage.contains('parking') || 
          lowerMessage.contains('car') || 
          lowerMessage.contains('vehicle')) {
        return getTranslation('en', 'parking');
      }
      if (lowerMessage.contains('hi') || 
          lowerMessage.contains('hello') || 
          lowerMessage.contains('hey')) {
        return getTranslation('en', 'greeting');
      }
      if (lowerMessage.contains('help') || 
          lowerMessage.contains('what can you do')) {
        return getTranslation('en', 'help');
      }
    }

    return getTranslation(languageCode, 'default');
  }
} 