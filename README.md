# SickBall - Flutter Sick Leave Generator App

A Flutter application that helps users generate creative and believable sick leave reasons while tracking usage to avoid repetition.

## Features

- **Google Authentication**: Secure login with Google account
- **Smart Reason Generation**: Generate random sick leave reasons from a curated database
- **Usage Tracking**: Track which reasons have been used to avoid repetition
- **Statistics Dashboard**: View sick leave statistics (monthly, yearly, total)
- **Social Sharing**: Share sick leave reasons via WhatsApp and other messaging apps
- **Modern UI**: Clean, intuitive Material Design interface

## Tech Stack

- **Frontend**: Flutter
- **Authentication**: Firebase Authentication (Google Sign-in)
- **Database**: Cloud Firestore
- **State Management**: Provider
- **Social Sharing**: share_plus package
- **Platform**: Cross-platform (iOS, Android, Web)

## Database Structure

### Collections:

1. **users**
   ```json
   {
     "uid": "string",
     "email": "string", 
     "name": "string",
     "totalSickDays": "number",
     "createdAt": "timestamp"
   }
   ```

2. **sick_leaves**
   ```json
   {
     "userId": "string",
     "reason": "string",
     "date": "timestamp", 
     "createdAt": "timestamp"
   }
   ```

3. **reasons**
   ```json
   {
     "text": "string",
     "category": "string",
     "lastUsedBy": "string?",
     "lastUsedDate": "timestamp?"
   }
   ```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.7.2)
- Firebase project configured
- Google Sign-in configured for your Firebase project

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sick_ball
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication and Firestore Database
   - Enable Google Sign-in provider
   - Run the FlutterFire CLI to configure your project:
     ```bash
     flutter pub global activate flutterfire_cli
     flutterfire configure
     ```
   - This will generate `firebase_options.dart` with your project configuration

4. **Google Sign-in Setup**
   - Configure OAuth 2.0 credentials in Google Cloud Console
   - Add your app's package name and signing certificate
   - Download and configure the appropriate config files

### Running the App

```bash
flutter run
```

For specific platforms:
```bash
flutter run -d chrome    # Web
flutter run -d ios       # iOS Simulator  
flutter run -d android   # Android Emulator
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   ├── sick_leave_model.dart
│   └── reason_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   └── sick_leave_provider.dart
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── dashboard_screen.dart
└── services/                 # Business logic
    ├── auth_service.dart
    └── firestore_service.dart
```

## Key Features Explained

### Smart Reason Generation
- Curated database of believable sick leave reasons
- Tracks usage per user to avoid repetition
- Categorized reasons (illness, medical, emergency, etc.)
- Falls back to all reasons if user has exhausted unused ones

### Statistics Tracking
- Monthly sick leave count
- Yearly sick leave count  
- Total lifetime sick days
- Visual dashboard with statistics

### Social Sharing
- One-tap sharing to messaging apps
- Pre-formatted messages for professional communication
- Integration with device sharing capabilities

## Firebase Configuration

The app requires proper Firebase configuration. Update `lib/firebase_options.dart` with your project details:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-android-api-key',
  appId: 'your-android-app-id', 
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

## Build for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS  
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Security Considerations

- All user data is stored securely in Firebase Firestore
- Authentication handled by Firebase Auth
- User data is isolated per authenticated user
- No sensitive information stored locally

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Ensure `firebase_options.dart` is properly configured
2. **Google Sign-in fails**: Check OAuth configuration in Google Cloud Console
3. **Build errors**: Run `flutter clean && flutter pub get`

### Debug Commands
```bash
flutter doctor          # Check Flutter installation
flutter analyze         # Static analysis
flutter test            # Run tests
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This app is for educational and entertainment purposes. Please use responsibly and in accordance with your company's policies regarding sick leave.
