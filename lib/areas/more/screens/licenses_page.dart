import 'package:fb4_app/areas/more/viewmodels/licenses_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LicensesPageViewModel>(
      onViewModelCreated: (viewModel) => viewModel.load(),
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
