import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {

  final TextEditingController controller = TextEditingController();

  void saveHabit() {
    if (controller.text.isEmpty) return;

    final box = Hive.box<Habit>('habits');

    box.add(
      Habit(name: controller.text),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Habit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Habit Name",
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveHabit,
              child: const Text("Save Habit"),
            )
          ],
        ),
      ),
    );
  }
}