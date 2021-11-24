import 'dart:convert';

import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:http/http.dart' as http;

class CanteensRepository {
  List<Canteen> cached = [];

  Future<List<Canteen>> getAll() async {
    if (cached.isEmpty) {
      cached = await http
          .get(Uri.parse('https://openmensa.org/api/v2/canteens'))
          .then((result) {
        if (result.statusCode == 200) {
          final data = jsonDecode(utf8.decode(result.bodyBytes));
          return data
              .map<Canteen>(
                  (item) => Canteen.fromJson(item as Map<String, dynamic>))
              .toList() as List<Canteen>;
        } else {
          return [];
        }
      });
    }

    return cached;
  }
}
