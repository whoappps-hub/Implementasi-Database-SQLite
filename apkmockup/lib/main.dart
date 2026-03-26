import 'package:flutter/material.dart';

import 'welcomepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mockupapk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF38241D)
      ),
      home: const WelcomePage(),
      routes: {'/welcome': (context) => const WelcomePage()},
      );
  }
}

