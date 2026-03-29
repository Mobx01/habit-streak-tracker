import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Calculate the user's highest historical streak across all habits
  int _getHighestStreak(Box<Habit> box) {
    int best = 0;
    for (var habit in box.values) {
      if (habit.streak > best) best = habit.streak;
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Habit>('habits');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2027), 
            Color(0xFF203A43), 
            Color(0xFF2C5364)
          ], // Sleek Dark Theme from 11.7
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Profile & Achievements", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Habit> box, _) {
            final bestStreak = _getHighestStreak(box);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 11.6 USER PROFILE HEADER ---
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF38BDF8).withOpacity(0.2),
                          child: const Icon(Icons.person, size: 50, color: Color(0xFF38BDF8)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Habit Champion",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Best Overall Streak: $bestStreak Days",
                          style: const TextStyle(fontSize: 16, color: Colors.amberAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- 11.5 BADGES AND ACHIEVEMENTS ---
                  const Text(
                    "Achievements",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildBadge("Bronze Starter", "3 Day Streak", Icons.local_fire_department, bestStreak >= 3, Colors.orangeAccent),
                      _buildBadge("Silver Consistent", "7 Day Streak", Icons.shield, bestStreak >= 7, Colors.grey.shade400),
                      _buildBadge("Gold Dedicated", "30 Day Streak", Icons.emoji_events, bestStreak >= 30, Colors.amber),
                      _buildBadge("Master", "100 Day Streak", Icons.diamond, bestStreak >= 100, Colors.cyanAccent),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // --- 11.6 PROFILE AND SETTINGS ---
                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingTile(Icons.dark_mode, "Dark Theme", trailing: Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFF38BDF8))),
                        const Divider(color: Colors.white24, height: 1),
                        _buildSettingTile(Icons.notifications, "Notifications", trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)),
                        const Divider(color: Colors.white24, height: 1),
                        _buildSettingTile(Icons.logout, "Logout", textColor: Colors.redAccent, iconColor: Colors.redAccent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper widget for Badges (11.5)
  Widget _buildBadge(String title, String subtitle, IconData icon, bool isUnlocked, Color badgeColor) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? badgeColor.withOpacity(0.15) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? badgeColor.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked ? icon : Icons.lock_outline,
            size: 40,
            color: isUnlocked ? badgeColor : Colors.white38,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUnlocked ? Colors.white : Colors.white54,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isUnlocked ? Colors.white70 : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Settings List (11.6)
  Widget _buildSettingTile(IconData icon, String title, {Widget? trailing, Color? textColor, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.white70),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w500)),
      trailing: trailing,
      onTap: () {
        // Handle setting tap
      },
    );
  }
}