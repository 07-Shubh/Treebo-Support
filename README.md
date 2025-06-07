# Treebo Self Check-in App

A Flutter-based mobile application that allows guests to complete self check-in/check-out processes, verify documents using AI, interact with an AI chatbot, and purchase add-ons during their stay.

## Features

- **Self Check-in/Check-out**: Streamlined process for guests to check in and out without front desk assistance
- **AI Document Verification**: Upload and verify ID documents (Aadhar, PAN, Driving License) using AI
- **Digital Signature Capture**: Secure collection of guest signatures during check-in
- **Add-ons Purchase**: Browse and purchase additional services (breakfast, spa, etc.)
- **AI Chatbot**: 24/7 assistance for guest queries about hotel services
- **Bill Review**: Transparent view of all charges before checkout
- **Feedback Collection**: Simple rating system to collect guest feedback

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **UI Components**: Material Design with custom theming
- **Networking**: http package for API calls
- **Local Storage**: shared_preferences for local data persistence
- **Image Picking**: image_picker for document uploads
- **Signature Capture**: flutter_signature_pad for digital signatures
- **Styling**: Google Fonts for consistent typography

## Setup Instructions

1. **Prerequisites**
   - Flutter SDK (latest stable version)
   - Android Studio / Xcode (for emulator/simulator)
   - VS Code or Android Studio (recommended IDEs)

2. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd treebo_self_checkin
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── constants/          # App constants and configurations
├── models/             # Data models
├── screens/            # App screens
│   ├── addons_screen.dart
│   ├── auth_screen.dart
│   ├── checkin_confirmation_screen.dart
│   ├── checkout_screen.dart
│   ├── document_verification_screen.dart
│   ├── home_screen.dart
│   ├── signature_screen.dart
│   └── splash_screen.dart
├── services/           # API and business logic
├── utils/              # Helper functions and utilities
├── widgets/            # Reusable widgets
│   └── ai_chat_bot.dart
├── main.dart           # App entry point
└── README.md
```

## Configuration

1. **API Endpoints**
   - Update the API endpoints in `lib/constants/api_constants.dart`
   - Configure authentication tokens and API keys as needed

2. **Theming**
   - Customize the app theme in `lib/main.dart`
   - Update colors in the `ThemeData` to match Treebo's brand guidelines

## Dependencies

- cupertino_icons: ^1.0.6
- google_fonts: ^6.1.0
- image_picker: ^1.0.7
- http: ^1.1.0
- provider: ^6.1.1
- shared_preferences: ^2.2.2
- flutter_svg: ^2.0.10+1
- camera: ^0.10.5
- path_provider: ^2.1.1
- path: ^1.8.3
- intl: ^0.18.1
- flutter_signature_pad: ^3.0.0
- image: ^4.1.3

## Screenshots

(Add screenshots of the app here)

## Future Enhancements

- Implement real API integration with Treebo's backend
- Add push notifications for check-in/check-out reminders
- Integrate with payment gateways for seamless transactions
- Add support for multiple languages
- Implement dark mode
- Add more detailed analytics and reporting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Treebo Hotels for the inspiration
- Flutter community for amazing packages and support
