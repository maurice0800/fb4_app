import 'dart:convert';

import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:fb4_app/areas/canteen/models/meal.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/core.dart';

class MealsRepository {
  final Map<int, List<Meal>> cache = {};

  Future<List<Meal>> getMealsForCanteen(Canteen c, String dateCode) async {
    final hash = hash2(c, dateCode);

    if (cache.containsKey(hash)) {
      return cache[hash]!;
    }

    return http
        .get(Uri.parse(
            'http://fb4app.hemacode.de/getMeals.php?location=${c.city}&mensa=${c.id}&date=$dateCode'))
        .then((result) {
      if (result.statusCode == 200) {
        final data = jsonDecode(utf8.decode(result.bodyBytes));
        final list = data
            .map<Meal>((item) => Meal.fromJson(item as Map<String, dynamic>))
            .toList() as List<Meal>;

        cache[hash] = list;
        return list;
      } else {
        return [];
      }
    });
  }
}
