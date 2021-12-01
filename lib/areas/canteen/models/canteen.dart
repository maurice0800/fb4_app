class Canteen {
  final int id;
  final String name;
  final String city;

  Canteen({required this.id, required this.name, required this.city});

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: int.parse(json["id"].toString()),
      name: json["name"].toString(),
      city: json["city"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "city": city};
  }
}