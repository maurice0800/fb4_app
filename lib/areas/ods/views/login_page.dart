import 'package:fb4_app/areas/ods/viewmodels/login_page_viewmodel.dart';
import 'package:fb4_app/areas/ods/views/grade_overview_page.dart';
import 'package:fb4_app/utils/helpers/cupertino_info_dialog.dart';
import 'package:fb4_app/utils/ui/widgets/cupertino_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginPageViewModel(),
      child: Consumer<LoginPageViewModel>(
        builder: (context, viewModel, child) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Login"),
            backgroundColor: CupertinoTheme.of(context).primaryColor,
          ),
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                Text("Mobile"),
                SizedBox(height: 40),
                CupertinoTextField(
                  placeholder: 'Benutzername',
                  controller: viewModel.usernameController,
                ),
                SizedBox(height: 20),
                CupertinoTextField(
                  placeholder: 'Passwort',
                  controller: viewModel.passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                CupertinoCheckBox(
                  isChecked: viewModel.isSaveCredentialsChecked,
                  onChanged: (value) =>
                      viewModel.isSaveCredentialsChecked = value,
                  caption: "Logindaten speichern",
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(CupertinoIcons.padlock),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        "Die Logindaten werden verschlüsselt auf deinem Gerät in der Keychain gespeichert.",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                CupertinoButton(
                  child: viewModel.isLoggingIn
                      ? CupertinoActivityIndicator()
                      : Text("Login"),
                  onPressed: () async {
                    bool result = await viewModel.login();

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
                  color: CupertinoTheme.of(context).primaryColor,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
