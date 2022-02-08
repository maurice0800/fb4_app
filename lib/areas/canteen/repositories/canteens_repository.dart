import 'package:fb4_app/areas/canteen/models/canteen.dart';

class CanteensRepository {
  Future<List<Canteen>> getAll() async {
    return [
      Canteen(
        id: "hauptmensa",
        name: "Hauptmensa",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "archeteria",
        name: "Archeteria",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "cafec",
        name: "Café C",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "food-fakultaet",
        name: "food fakultät",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "galerie",
        name: "Mensa Galerie",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "genusswerkstatt",
        name: "Genusswerkstatt",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "mensa-sued",
        name: "Mensa Süd",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "restaurant-calla",
        name: "Restaurant Calla",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "vital",
        name: "Mensa Vital",
        city: "tu-dortmund",
      ),
      Canteen(
        id: "mensa-kostbar",
        name: "Mensa kostBar",
        city: "fh-dortmund",
      ),
      Canteen(
        id: "max-ophuels-platz",
        name: "Max Ophuels Platz",
        city: "fh-dortmund",
      ),
      Canteen(
        id: "sonnenstrasse",
        name: "Sonnenstrasse",
        city: "fh-dortmund",
      ),
    ];
  }
}
