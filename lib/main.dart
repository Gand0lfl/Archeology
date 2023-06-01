import 'package:archeology/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:archeology/screens/splash_screen.dart';
import 'package:archeology/screens/auth/login_screen_ui.dart';
import 'package:archeology/screens/auth/signup_screen_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF00AEEF);
    final primarySwatch = MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    });

    return MaterialApp(
      title: 'Справочник Археолога: Сибирские остроги',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        appBarTheme: AppBarTheme(
          color: primaryColor, toolbarTextStyle: const TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).bodyText2, titleTextStyle: const TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).headline6,
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(email: '', password: ''),
      },
    );
  }
}
