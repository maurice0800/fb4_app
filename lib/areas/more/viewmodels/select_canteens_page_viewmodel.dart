import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:fb4_app/areas/canteen/repositories/canteens_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

class SelectCanteensPageViewModel extends ChangeNotifier {
  late CanteensRepository _canteensRepository;
  List<Canteen> canteens = [];
  List<Canteen> selectedCanteens = [];

  SelectCanteensPageViewModel() {
    _canteensRepository = KiwiContainer().resolve<CanteensRepository>();
  }

  Future getAllCanteens() async {
    canteens = await _canteensRepository.getAll();
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setSelectedState(Canteen canteen, bool state) {
    if (state) {
      selectedCanteens.add(canteen);
    } else {
      selectedCanteens.remove(canteen);
    }

    notifyListeners();
  }
}
