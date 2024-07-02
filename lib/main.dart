import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home/home_screen.dart';
import 'styles/text_theme.dart';
import 'styles/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffe Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyColor.primaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(myTextTheme),
      ),
      home: const HomeScreen(),
    );
  }
}
