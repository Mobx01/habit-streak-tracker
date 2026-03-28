import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onChanged;

  const HabitTile({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: CheckboxListTile(
          title: Text(
            habit.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // --- STREAK DISPLAY ADDED HERE ---
          subtitle: Text(
            '🔥 ${habit.streak} Day Streak',
            style: TextStyle(
              color: habit.streak > 0 ? Colors.deepOrange : Colors.grey.shade500,
              fontWeight: habit.streak > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          value: isCompleted,
          onChanged: onChanged,
          // Make the checkbox a bit more prominent
          activeColor: Colors.deepPurple, 
        ),
      ),
    );
  }
}