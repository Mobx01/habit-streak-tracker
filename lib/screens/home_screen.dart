import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import 'add_habit_screen.dart';

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

                return HabitTile(
                  habit: habit,

                  onDelete: () {
                    habit.delete();
                  },

                  onChanged: (value) {
                    habit.isCompleted = value!;
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