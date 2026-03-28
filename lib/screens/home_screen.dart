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
),