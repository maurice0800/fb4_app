import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fb4_app/areas/more/viewmodels/licenses_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LicensesPageViewModel>(
      builder: (context, viewModel, child) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Lizenzen"),
          backgroundColor: ColorConsts.mainOrange,
        ),
        child: Material(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            child: ListView.separated(
                padding: const EdgeInsets.only(top: 16.0),
                itemCount: viewModel.licenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor:
                        CupertinoTheme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      viewModel.licenses[index].title,
                      style: TextStyle(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      ),
                    ),
                    subtitle: Text(
                      viewModel.licenses[index].description,
                      style: TextStyle(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color:
                          CupertinoTheme.of(context).textTheme.textStyle.color,
                    ),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => LicenseDetailsPage(
                          license: viewModel.licenses[index],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider())),
      ),
    );
  }
}

class LicenseDetailsPage extends StatelessWidget {
  final LicenseInfo license;

  const LicenseDetailsPage({
    Key? key,
    required this.license,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoTheme.of(context).primaryColor,
        middle: Text(license.title),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(license.licenseText),
          ),
        ),
      ),
    );
  }
}
