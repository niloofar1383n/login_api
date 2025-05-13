import 'package:flutter/material.dart';
import 'package:login_api/pages/login_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "login_api",
      debugShowCheckedModeBanner: false,
      locale: Locale("fa"),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: false
      ),
      home: loginpage(),
    );
  }
}