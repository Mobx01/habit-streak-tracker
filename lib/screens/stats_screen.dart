import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../models/habit.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // This function gathers all completed dates across all habits
  // and counts how many habits were completed on each day.
  Map<DateTime, int> _prepHeatmapData(Box<Habit> box) {
    Map<DateTime, int> dataset = {};
    for (var habit in box.values) {
      for (var date in habit.completedDays) {
        // Normalize the date so we only care about Year/Month/Day (ignore time)
        DateTime normalizedDate = DateTime(date.year, date.month, date.day);
        
        // Increment the count for this date
        dataset[normalizedDate] = (dataset[normalizedDate] ?? 0) + 1;
      }
    }
    return dataset;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Habit>('habits');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        centerTitle: true,
      ),
      // Listen to the box so the heatmap updates if you check off a habit
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Habit> box, _) {
          
          final heatmapData = _prepHeatmapData(box);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Activity Heatmap",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // The actual Heatmap Widget
                HeatMapCalendar(
                  datasets: heatmapData,
                  colorMode: ColorMode.opacity,
                  colorsets: const {
                    1: Colors.deepPurple, // The base color that will get darker
                  },
                  onClick: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Activity on ${value.toString().split(' ')[0]}')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}