import 'package:flutter/material.dart';
import 'views/splash/splash_screen.dart';

void main() {
  runApp(const DigitalBinderApp());
}

class DigitalBinderApp extends StatelessWidget {
  const DigitalBinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Binder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}