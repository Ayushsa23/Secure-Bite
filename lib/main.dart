import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secure_bite/firebase_options.dart';
import 'package:secure_bite/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global theme mode notifier
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SplashScreen()); // Show splash screen while initializing
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Load theme mode from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode') ?? 'light';
    themeModeNotifier.value = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
    runApp(App());
  } catch (e) {
    print("Firebase initialization error: $e");
    runApp(ErrorApp()); // Show error screen if Firebase fails
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Secure-Bite',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Color(0xFFF0F4F8),
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(0xFF00C853),
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Color(0xFF181A20),
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(0xFF222831),
              foregroundColor: Colors.white,
            ),
            cardColor: Color(0xFF23272F),
            dialogBackgroundColor: Color(0xFF23272F),
          ),
          themeMode: mode,
          home: LoginPage(),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Failed to initialize Firebase."),
        ),
      ),
    );
  }
}
