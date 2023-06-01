import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MapScreen extends StatelessWidget {
  final String mapUrl =
      'https://www.google.com/maps/d/u/0/embed?mid=1FG_2howUe_Z_iomwp2wEhUEY9mItcb0&ehbc=2E312F&ll=56.99470463206552%2C79.9950259061471&z=5';

@override
  Widget build(BuildContext context) {
    if (mapUrl.isEmpty) {
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
                initialUrlRequest: URLRequest(url: Uri.parse(mapUrl)),
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
