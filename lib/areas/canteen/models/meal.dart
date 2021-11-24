import 'dart:convert';

class Meal {
  final String name;
  final String category;
  final Map<String, double?> prices;
  final List<String> notes;

  Meal(
      {required this.name,
      required this.category,
      required this.prices,
      required this.notes});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json["name"].toString(),
      category: json["category"].toString(),
      prices: (json["prices"] as Map).map((k, v) => MapEntry(
          k.toString(), v != null ? double.parse(v.toString()) : null)),
      notes: json["notes"].map<String>((item) => item.toString()).toList()
          as List<String>,
    );
  }
}
