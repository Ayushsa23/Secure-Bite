# Secure-Bite

Secure-Bite is a modern Flutter application designed to help users make healthier food choices, manage dietary preferences, and track allergens. The app features a beautiful UI, Firebase authentication, and a customizable user experience with light/dark mode support.

## Features

- **User Authentication:** Sign up, log in, and password reset using Firebase Auth.
- **Personalized Home Page:** Dynamic banners, featured products, healthy tips, and recent products.
- **Product Details:** View healthy and unhealthy properties of food items, with image zoom and filtering.
- **User Profile:** Edit profile, toggle dark mode, manage notifications, and allergen alerts.
- **Preferences & Allergens:** Add and manage dietary preferences and allergens via the app drawer.
- **Modern UI:** Glassmorphism, gradients, and responsive layouts with Google Fonts.
- **Persistent Theme:** Remembers user's theme preference (light/dark) using shared preferences.

## Screenshots
<!-- Add screenshots of the app here if available -->

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.6.0)
- A configured Firebase project (see below)

### Installation
1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd Secure-Bite
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Firebase Setup:**
   - Ensure you have your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) configured.
   - The app uses `firebase_core` and `firebase_auth` for authentication.
   - Firebase options are managed in `lib/firebase_options.dart`.

4. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
  main.dart                # App entry point, theme, and routing
  firebase_options.dart    # Firebase configuration
  screen/
    home_page.dart         # Home page with banners, tips, products
    login_page.dart        # Login screen
    sign_up.dart           # Registration screen
    forgot_password.dart   # Password reset
    user_profile.dart      # User profile and settings
    productdetails.dart    # Product details view
    app_drawer.dart        # Drawer for preferences and allergens
    scrolling_label.dart   # Custom widgets
assets/                    # App images and logos
```

## Dependencies

- flutter
- firebase_core
- firebase_auth
- google_fonts
- google_sign_in
- flutter_svg
- image_picker
- flutter_animate
- lottie
- flutter_spinkit
- fluttertoast
- font_awesome_flutter
- shared_preferences

See `pubspec.yaml` for full details.

## Assets

The app uses several images and logos located in the `assets/` directory. Make sure all assets listed in `pubspec.yaml` are present for the app to run correctly.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

This project is private and not published to pub.dev. Remove the `publish_to: 'none'` line in `pubspec.yaml` if you wish to publish.
