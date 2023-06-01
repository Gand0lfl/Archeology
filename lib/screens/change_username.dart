import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeUsernameScreen extends StatefulWidget {
  final String currentUsername;

  ChangeUsernameScreen({required this.currentUsername});

  @override
  _ChangeUsernameScreenState createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  TextEditingController _usernameController = TextEditingController();
  String _newUsername = '';

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.currentUsername;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('CustomUsername', _newUsername);
    await prefs.setBool('useCustomUsername', true);
    await prefs.setString('ChatName', _newUsername);
    Navigator.pop(context, _newUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменить имя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Текущее имя:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              widget.currentUsername,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Новое имя:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              onChanged: (value) {
                setState(() {
                  _newUsername = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Введите новое имя',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: (_newUsername.isNotEmpty) ? _saveUsername : null,
                child: Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
