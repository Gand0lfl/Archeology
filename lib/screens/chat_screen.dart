import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatName = 'Аноним';
  String url = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final customUsername = prefs.getString('CustomUsername');
    setState(() {
      chatName = customUsername ?? 'Аноним';
      url = 'http://192.168.56.101/?username=$chatName';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      // Пока данные загружаются, показываем заглушку или индикатор загрузки
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Когда данные доступны, отображаем WebView с правильной ссылкой
      return Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(url)),
                onWebViewCreated: (controller) {},
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: kBottomNavigationBarHeight,
          // Добавьте сюда вашу навигационную панель или другие элементы интерфейса
        ),
      );
    }
  }
}
