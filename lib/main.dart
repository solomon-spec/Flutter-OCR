import 'package:flutter/material.dart';
import 'package:flutter_ocr_app/home-page.dart';
import 'login_page.dart';
import 'registration_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: RegistrationPage(), // Default to HomePage
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}
