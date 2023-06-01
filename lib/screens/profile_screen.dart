import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archeology/screens/change_email.dart';
import 'package:archeology/screens/change_username.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  final VoidCallback onSignOut;

  ProfileScreen({required this.user, required this.onSignOut});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  String username = '';

  @override
  void initState() {
    _currentUser = widget.user;
    _getUsername(_currentUser?.email ?? '');
    super.initState();
  }

  Future<void> _getUsername(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final useCustomUsername = prefs.getBool('useCustomUsername') ?? false;
    final customUsername = prefs.getString('CustomUsername') ?? 'Аноним';

    if (useCustomUsername) {
      final splitEmail = email.split('@');
      username = splitEmail[0];
      if (splitEmail.length > 0) {
        setState(() {
          username = splitEmail[0];
        });
      }
    } else {
      setState(() {
        username = customUsername;
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('password');
    await prefs.remove('rememberMe');
    await prefs.remove('autoLogin');

    FirebaseAuth.instance.signOut();
    widget.onSignOut();
  }

  Future<void> _refreshUser() async {
    final updatedUser = await FirebaseAuth.instance.currentUser!;
    setState(() {
      _currentUser = updatedUser;
    });
  }

  Future<void> _editUsername() async {
    String? newUsername = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeUsernameScreen(currentUsername: username)),
    );

    if (newUsername != null) {
      // Update the username
      setState(() {
        username = newUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundSignIn(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          username,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: _editUsername,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.grey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Редактировать имя',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeEmailScreen(user: _currentUser!),
                      ),
                    );

                    // Refresh the user data after returning from ChangeEmailScreen
                    await _refreshUser();
                    _getUsername(_currentUser?.email ?? '');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.grey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: RichText(
                          text: TextSpan(
                            text: 'Изменить email\n',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            children: [
                              TextSpan(
                                text: _currentUser?.email ?? '',
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => _signOut(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.grey,
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Выйти из аккаунта',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    // Blue
    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.00005, sh * 0.95, sw * 0.52, sh * 0.1);
    blueWave.close();
    paint.color = Colors.blue.shade300;
    canvas.drawPath(blueWave, paint);

    // Grey
    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.65, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.7, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.52, 0.52, sh * 0.52);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);

    // Yellow
    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.9, 0.5);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.2, sh * 0.26, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.orange.shade300;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
