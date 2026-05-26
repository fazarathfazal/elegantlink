import 'package:flutter/material.dart';

// Brand colours — use these named constants throughout the code
const Color kBrandBlue    = Color(0xFF1F3864); // primary brand colour
const Color kBrandLight   = Color(0xFF2E5C8A); // secondary / AppBar
const Color kStatusGreen  = Color(0xFF388E3C); // complete / approved
const Color kStatusAmber  = Color(0xFFF9A825); // in progress / at risk
const Color kStatusRed    = Color(0xFFD32F2F); // blocked
const Color kStatusGrey   = Color(0xFF9E9E9E); // pending / read
const Color kSurface      = Color(0xFFF7FBFF); // background surface

void main() {
  runApp(const ElegantLinkApp());
}

/// The root widget of the ElegantLink application.
/// It configures the Material3 theme and sets the initial screen.
class ElegantLinkApp extends StatelessWidget {
  const ElegantLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElegantLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrandBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: kSurface,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBrandLight,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

/// LoginScreen simulates authentication for the portal.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ElegantLink Initializing...'),
      ),
    );
  }
}
