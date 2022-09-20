import 'package:fb4_app/areas/more/viewmodels/select_canteens_page_viewmodel.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class SelectCanteensPage extends StatelessWidget {
  const SelectCanteensPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Mensen auswählen"),
        backgroundColor: CupertinoTheme.of(context).primaryColor,
      ),
      child: BaseView<SelectCanteensPageViewModel>(
        onViewModelCreated: (viewModel) => viewModel.getAllCanteens(),
        builder: (context, viewModel, child) => viewModel.canteens.isNotEmpty
            ? CupertinoSettings(
                items: [
                  const CSHeader("Angezeigte Mensen"),
                  ...viewModel.canteens.map(
                    (c) => CSControl(
                      nameWidget: Text(c.name),
                      contentWidget: CupertinoSwitch(
                        value: viewModel.selectedCanteenIds
                            .any((element) => element == c.id),
                        onChanged: (value) =>
                            viewModel.setSelectedState(c, value),
                      ),
                    ),
                  )
                ],
              )
            : const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
