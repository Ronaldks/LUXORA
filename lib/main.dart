import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/shop_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShopProvider(),
      child: const LuxoraApp(),
    ),
  );
}

class LuxoraApp extends StatelessWidget {
  const LuxoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'LUXORA',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor:
        const Color(0xFFF8F7F4),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF171717),
        ),

        fontFamily: 'Roboto',
      ),

      home: const LoginScreen(),
    );
  }
}