import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the Hive box for habits
    final box = Hive.box<Habit>('habits');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Habit Tracker"),
          centerTitle: true,
        ),

        // ValueListenableBuilder listens to changes in the Hive box
        // and rebuilds the UI automatically when a habit is added, updated, or deleted.
        body: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Habit> box, _) {
            
            // Show a placeholder if the database is empty
            if (box.isEmpty) {
              return const Center(
                child: Text("Add your first habit"),
              );
            }

            // Build the list of habits
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
                  isCompleted: isCompletedToday, // Pass the calculated boolean
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
                    habit.save(); // Save the updated list to Hive
                  },
                );
              },
            );
          },
        ),

        // Floating Action Button to navigate to the Add Habit screen
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