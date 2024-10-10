import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'screen/screen_splash.dart';
import 'package:perpustakaan/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Library App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: textColor),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const ScreenSplash(),
    );
  }
}
