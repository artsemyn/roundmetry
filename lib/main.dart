import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roundmetry/app_router.dart'; // Import router kita
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MaterialApp.router untuk mengaktifkan go_router
    return MaterialApp.router(
      title: 'Round Metry',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Menggunakan google_fonts untuk font Inter
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      // Konfigurasi router dari file app_router.dart
      routerConfig: router,
    );
  }
}
