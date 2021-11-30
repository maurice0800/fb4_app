import 'package:fb4_app/main_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PrivacyPageViewModel extends ChangeNotifier {
  String licenseText = "";

  Future load() async {
    licenseText = await rootBundle.loadString('assets/privacy');
    notifyListeners();
  }

  void acceptPolicy(BuildContext context) {
    Provider.of<MainViewModel>(context, listen: false).acceptPrivacyPolicy();
  }
}
