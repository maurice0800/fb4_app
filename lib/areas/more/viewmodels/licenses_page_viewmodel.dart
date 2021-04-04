import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LicensesPageViewModel extends ChangeNotifier {
  String licenseText = "Laden...";

  void load() async {
    licenseText = await rootBundle.loadString('assets/licenses');
    notifyListeners();
  }
}
