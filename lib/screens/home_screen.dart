import 'package:archeology/screens/chat_screen.dart';
import 'package:archeology/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth/login_screen_ui.dart';
import 'profile_screen.dart';
import 'news_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _screens = [
      ListScreen(),
      MapScreen(),
      ChatScreen(),
      NewsScreen(),
      ProfileScreen(user: FirebaseAuth.instance.currentUser, onSignOut: _signOut,),
    ];
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();

    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(email: '', password: '',)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Color.fromARGB(255, 0, 174, 239),
            unselectedItemColor: Colors.grey,
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Список',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Карта',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Чат',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Новости',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
