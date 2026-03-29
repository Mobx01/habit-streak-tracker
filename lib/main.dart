import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'models/habit.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    
    
    // Now it creates a fresh, clean database for Phase 11.8
    await Hive.openBox<Habit>('habits');
    
    runApp(const MyApp());
    
  } catch (e, stacktrace) {
    print("FATAL ERROR: $e");
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  '🚨 APP CRASHED ON STARTUP 🚨\n\nERROR:\n$e\n\nSTACKTRACE:\n$stacktrace',
                  style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Streak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}