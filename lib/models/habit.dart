class Habit {
  String id;
  String name;
  DateTime createdAt;
  List<DateTime> completedDays;

  Habit({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.completedDays,
  });
}