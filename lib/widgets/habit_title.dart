import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onChanged;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.key.toString()),
      direction: DismissDirection.endToStart,

      onDismissed: (_) => onDelete(),

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        child: CheckboxListTile(
          title: Text(
            habit.name,
            style: const TextStyle(fontSize: 18),
          ),
          value: habit.isCompleted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}