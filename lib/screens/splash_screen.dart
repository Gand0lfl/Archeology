import 'package:flutter/material.dart';
import 'package:archeology/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archeology/services/firebase_auth_service.dart';
import 'package:archeology/screens/auth/login_screen_ui.dart';
import 'package:extended_image/extended_image.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final autoLogin = prefs.getBool('autoLogin') ?? false;

    if (autoLogin) {
      final email = prefs.getString('email');
      final password = prefs.getString('password');

      if (email != null && password != null) {
        final authService = FirebaseAuthService();
        final loginResult =
            await authService.signInWithEmailAndPassword(email, password);

        if (loginResult.success) {
          prefs.setBool('useCustomUsername', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return;
        }
      }
    }

    _navigateToLoginScreen();
  }

  Future<void> _navigateToLoginScreen() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useCustomUsername', true);
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(email: '', password: '')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 174, 239, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExtendedImage.asset(
              'assets/images/logo.gif', // Path to the animated GIF logo image
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              enableLoadState: false,
            ),
          ],
        ),
      ),
    );
  }
}
