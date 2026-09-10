import 'package:flutter/material.dart';
import 'package:mobile_flutter/providers/Auth_provider.dart';
import 'package:mobile_flutter/providers/Deck_provider.dart';
import 'package:mobile_flutter/providers/Study_provider.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DeckProvider()),
        ChangeNotifierProvider(create: (_) => StudyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SummQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.navy,
        primaryColor: AppColors.navy,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}