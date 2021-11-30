import 'package:fb4_app/oss_licenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LicensesPageViewModel extends ChangeNotifier {
  List<LicenseInfo> licenses = [];

  LicensesPageViewModel() {
    for (final license in ossLicenses.entries) {
      licenses.add(LicenseInfo(
        title: "${license.value["name"]} ${license.value["version"]}",
        description: license.value["description"].toString(),
        licenseText: license.value["license"].toString(),
      ));
    }
  }
}

class LicenseInfo {
  final String title;
  final String description;
  final String licenseText;

  LicenseInfo({
    required this.title,
    required this.description,
    required this.licenseText,
  });
}
