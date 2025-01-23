import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'intro-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IntroPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}
