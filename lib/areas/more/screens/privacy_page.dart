import 'package:fb4_app/areas/more/viewmodels/privacy_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPage extends StatelessWidget {
  final bool shouldAccept;

  const PrivacyPage({Key? key, this.shouldAccept = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PrivacyPageViewModel>(
      onViewModelCreated: (viewModel) => viewModel.load(),
      builder: (context, viewModel, child) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Datenschutz"),
          backgroundColor: ColorConsts.mainOrange,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: viewModel.licenseText,
                      styleSheet: MarkdownStyleSheet.fromCupertinoTheme(
                        CupertinoTheme.of(context),
                      ),
                    ),
                  ),
                ),
                if (shouldAccept)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CupertinoButton.filled(
                      child: const Text("Akzeptieren"),
                      onPressed: () => viewModel.acceptPolicy(context),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
