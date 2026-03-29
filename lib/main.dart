import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/habit.dart';
import 'screens/splash_screen.dart'; // IMPORT THE SPLASH SCREEN

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('habits');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Streak Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Setting up our primary colors from Section 11.7
        primaryColor: const Color(0xFF38BDF8),
        fontFamily: 'Poppins', // Make sure you have this font added in pubspec.yaml, or it will use the default font
      ),
      home: const SplashScreen(), // This now routes to the Splash Screen first
    );
  }
}