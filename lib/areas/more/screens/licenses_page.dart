import 'package:fb4_app/areas/more/viewmodels/licenses_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LicensesPageViewModel>(
      builder: (context, viewModel, child) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Lizenzen"),
          backgroundColor: ColorConsts.mainOrange,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Text(viewModel.licenseText),
            ),
          ),
        ),
      ),
    );
  }
}
