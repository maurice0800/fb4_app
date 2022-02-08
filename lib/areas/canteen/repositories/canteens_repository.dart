import 'package:fb4_app/areas/canteen/models/canteen.dart';

class CanteensRepository {
  List<Canteen> getAll() {
    return [
      Canteen(
        id: "hauptmensa",
        name: "Hauptmensa",
        city: "tu-dortmund",
        order: 1,
      ),
      Canteen(
        id: "archeteria",
        name: "Archeteria",
        city: "tu-dortmund",
        order: 4,
      ),
      Canteen(
        id: "cafec",
        name: "Café C",
        city: "tu-dortmund",
        order: 11,
      ),
      Canteen(
        id: "food-fakultaet",
        name: "food fakultät",
        city: "tu-dortmund",
        order: 2,
      ),
      Canteen(
        id: "galerie",
        name: "Mensa Galerie",
        city: "tu-dortmund",
        order: 3,
      ),
      Canteen(
        id: "genusswerkstatt",
        name: "Genusswerkstatt",
        city: "tu-dortmund",
        order: 6,
      ),
      Canteen(
        id: "mensa-sued",
        name: "Mensa Süd",
        city: "tu-dortmund",
        order: 7,
      ),
      Canteen(
        id: "restaurant-calla",
        name: "Restaurant Calla",
        city: "tu-dortmund",
        order: 8,
      ),
      Canteen(
        id: "vital",
        name: "Mensa Vital",
        city: "tu-dortmund",
        order: 9,
      ),
      Canteen(
        id: "mensa-kostbar",
        name: "Mensa kostBar",
        city: "fh-dortmund",
        order: 10,
      ),
      Canteen(
        id: "max-ophuels-platz",
        name: "Max Ophuels Platz",
        city: "fh-dortmund",
        order: 5,
      ),
      Canteen(
        id: "sonnenstrasse",
        name: "Sonnenstrasse",
        city: "fh-dortmund",
        order: 12,
      ),
    ];
  }
}
