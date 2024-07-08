import 'package:coffeonline/firebase_option.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/home/home_screen.dart';
import 'screens/login/provider/auth_service.dart';
import 'screens/login/register_screen.dart';
import 'screens/login/login_screen.dart';
import 'styles/text_theme.dart';
import 'styles/colors.dart';
import 'providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    printLog('Firebase Initialized');
  } catch (e) {
    printLog('Failed to initialize Firebase: $e');
  }
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [...providers],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Go Coffe',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: MyColor.primaryColor,
            textTheme: GoogleFonts.poppinsTextTheme(myTextTheme),
          ),
          initialRoute: value.token.isEmpty ? '/login' : '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
          },
        );
      },
    );
  }
}
