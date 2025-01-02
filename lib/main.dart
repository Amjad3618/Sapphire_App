import 'package:flutter/material.dart';

import 'bottom_bar/bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
      scaffoldBackgroundColor: Colors.grey[300],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange
        
      ),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.orange),
      ),
     ),
        useMaterial3: true,
      ),
      home:BottomBar()
    );
  }
}
