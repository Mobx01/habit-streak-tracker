import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:confetti/confetti.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import 'add_habit_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart'; // IMPORT THE PROFILE SCREEN

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Initialize Confetti Controller
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // --- 11.3 DYNAMIC GREETING ---
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // Calculate daily completion progress
  double _getDailyProgress(Box<Habit> box) {
    if (box.isEmpty) return 0.0;
    
    int completedToday = 0;
    final today = DateTime.now();
    
    for (var habit in box.values) {
      bool isCompleted = habit.completedDays.any((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day);
      if (isCompleted) completedToday++;
    }
    return completedToday / box.length;
  }

  // Calculate total combined streak overview
  int _getTotalActiveStreaks(Box<Habit> box) {
    int totalStreaks = 0;
    for (var habit in box.values) {
      totalStreaks += habit.streak;
    }
    return totalStreaks;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Habit>('habits');

    return Stack(
      children: [
        // Main Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8A2387), // Deep Purple
                Color(0xFFE94057), // Vibrant Pink
                Color(0xFFF27121), // Sunset Orange
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 0),
                  ],
                ),
              ),
              centerTitle: false,
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                // Stats Screen Button
                IconButton(
                  icon: const Icon(Icons.bar_chart, size: 30),
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const StatsScreen()),
                  ),
                ),
                // --- INTEGRATED PROFILE SCREEN BUTTON ---
                IconButton(
                  icon: const Icon(Icons.person, size: 30),
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Habit> box, _) {
                double progress = _getDailyProgress(box);
                int totalStreak = _getTotalActiveStreaks(box);

                return CustomScrollView(
                  slivers: [
                    // --- 11.3 HOME DASHBOARD HEADER ---
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_getGreeting()}, Champion! 🔥",
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Overview Card (Progress Bars & Streak Overview)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Today's Progress",
                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${(progress * 100).toInt()}%",
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // --- 11.3 PROGRESS BAR ---
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 12,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // --- 11.3 CURRENT STREAK OVERVIEW ---
                                  Row(
                                    children: [
                                      const Icon(Icons.bolt, color: Colors.amberAccent),
                                      const SizedBox(width: 8),
                                      Text(
                                        "$totalStreak Total Active Streaks",
                                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Habit List
                    box.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(
                              child: Text(
                                "Add your first habit",
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final habit = box.getAt(index)!;
                                final today = DateTime.now();
                                bool isCompletedToday = habit.completedDays.any((date) =>
                                    date.year == today.year &&
                                    date.month == today.month &&
                                    date.day == today.day);

                                // --- 11.3 ANIMATED HABIT CARDS ---
                                return TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 400 + (index * 100)),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, double value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 50 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: HabitTile(
                                    habit: habit,
                                    isCompleted: isCompletedToday,
                                    onDelete: () => habit.delete(),
                                    onChanged: (value) {
                                      if (value == true) {
                                        habit.completedDays.add(today);
                                        // --- 11.3 CONFETTI ANIMATION ON COMPLETION ---
                                        _confettiController.play();
                                      } else {
                                        habit.completedDays.removeWhere((date) =>
                                            date.year == today.year &&
                                            date.month == today.month &&
                                            date.day == today.day);
                                      }
                                      habit.save();
                                    },
                                  ),
                                );
                              },
                              childCount: box.length,
                            ),
                          ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white.withOpacity(0.3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddHabitScreen()),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),

        // --- CONFETTI WIDGET LAYER ---
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            gravity: 0.2,
            emissionFrequency: 0.05,
          ),
        ),
      ],
    );
  }
}