import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import 'add_habit_screen.dart';
import 'stats_screen.dart'; // Added the import for the stats screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Habit>('habits');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Habit Tracker"),
          centerTitle: true,
          // --- ADDED THE STATS BUTTON HERE ---
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StatsScreen(),
                  ),
                );
              },
            )
          ],
        ),

        body: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Habit> box, _) {
            
            if (box.isEmpty) {
              return const Center(
                child: Text("Add your first habit"),
              );
            }

            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final habit = box.getAt(index)!;

                // 1. Check if today's date exists in the completedDays list
                final today = DateTime.now();
                bool isCompletedToday = habit.completedDays.any((date) =>
                    date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day);

                return HabitTile(
                  habit: habit,
                  isCompleted: isCompletedToday, 
                  onDelete: () {
                    habit.delete();
                  },
                  onChanged: (value) {
                    // 2. Add or remove today's date based on the checkbox
                    if (value == true) {
                      habit.completedDays.add(today);
                    } else {
                      habit.completedDays.removeWhere((date) =>
                          date.year == today.year &&
                          date.month == today.month &&
                          date.day == today.day);
                    }
                    habit.save(); 
                  },
                );
              },
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddHabitScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}