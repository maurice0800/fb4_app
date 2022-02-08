class Meal {
  final String type;
  final String title;
  final Map<String, double?> prices;
  final List<String> notes;

  Meal(
      {required this.type,
      required this.title,
      required this.prices,
      required this.notes});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      type: json["type"].toString(),
      title: json["title"].toString(),
      prices: {
        "Studierende": double.parse(json["priceStudent"].toString()),
        "Mitarbeitende": double.parse(json["priceEmployee"].toString()),
        "Gäste": double.parse(json["priceGuest"].toString()),
      },
      notes: json["supplies"].map<String>((item) => item.toString()).toList()
          as List<String>,
    );
  }
}
