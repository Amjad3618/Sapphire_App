import 'package:flutter/material.dart';
import 'package:genrator_11/screens/login_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sapphire App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(backgroundColor: Colors.orange),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.orange),
            ),
          ),
          useMaterial3: true,
        ),
        home: LoginScreen());
  }
}
