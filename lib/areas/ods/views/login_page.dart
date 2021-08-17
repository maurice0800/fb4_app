import 'package:fb4_app/areas/ods/viewmodels/login_page_viewmodel.dart';
import 'package:fb4_app/areas/ods/views/grade_overview_page.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:fb4_app/utils/helpers/cupertino_info_dialog.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginPageViewModel>(
      builder: (context, viewModel, child) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Login"),
          backgroundColor: CupertinoTheme.of(context).primaryColor,
          trailing: GestureDetector(
            onTap: () async {
              final result = await viewModel.login() ?? false;

              if (result) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => GradeOverViewPage()));
              } else {
                CupertinoInfoDialog(context, "Fehler",
                        "Beim Login ist ein Fehler aufgetreten. Sind Benutzername oder Passwort falsch?")
                    .show();
              }
            },
            child: viewModel.isLoggingIn
                ? const CupertinoActivityIndicator()
                : const Text(
                    "Login",
                    style:
                        TextStyle(fontSize: 16, color: CupertinoColors.white),
                  ),
          ),
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Text(
                "ODS",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: CupertinoTheme.of(context).primaryColor,
                ),
              ),
              const Text("Mobile"),
              const SizedBox(height: 40),
              CupertinoFormSection(children: [
                CupertinoTextFormFieldRow(
                  prefix: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child:
                        Text("Benutzername", style: TextStyle(fontSize: 16.0)),
                  ),
                  controller: viewModel.usernameController,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  style: const TextStyle(fontSize: 16.0),
                  enableSuggestions: false,
                ),
                CupertinoTextFormFieldRow(
                  prefix: const Padding(
                    padding: EdgeInsets.only(right: 57.0),
                    child: Text("Passwort", style: TextStyle(fontSize: 16.0)),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  controller: viewModel.passwordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 16.0),
                  enableSuggestions: false,
                ),
                CupertinoFormRow(
                  prefix: const Text("Passwort speichern",
                      style: TextStyle(fontSize: 16.0)),
                  child: CupertinoSwitch(
                    value: viewModel.isSaveCredentialsChecked,
                    onChanged: (value) =>
                        viewModel.isSaveCredentialsChecked = value,
                  ),
                )
              ]),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, bottom: 20.0, right: 20.0),
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.padlock),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        "Die Logindaten werden verschlüsselt in der Keychain auf deinem Gerät gespeichert.",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        )),
      ),
    );
  }
}
