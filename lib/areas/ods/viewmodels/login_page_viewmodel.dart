import 'package:fb4_app/areas/ods/repositories/ods_repository.dart';
import 'package:fb4_app/areas/ods/services/ods_authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPageViewModel extends ChangeNotifier {
  final Function(String) onError;
  bool _isSaveCredentialsChecked = true;
  bool isLoggingIn = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPageViewModel({this.onError});

  set isSaveCredentialsChecked(bool value) {
    _isSaveCredentialsChecked = value;
    notifyListeners();
  }

  bool get isSaveCredentialsChecked {
    return _isSaveCredentialsChecked;
  }

  Future<bool> login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      return Future.value(false);
    }

    isLoggingIn = true;
    notifyListeners();

    return OdsAuthenticationService.getAuthToken(username, password)
        .then((token) {
      if (token.isNotEmpty) {
        if (isSaveCredentialsChecked) {
          FlutterSecureStorage().write(key: 'odsUsername', value: username);
          FlutterSecureStorage().write(key: 'odsPassword', value: password);
        }

        OdsRepository.cachedToken = token;
        return true;
      }
    }).onError((error, stackTrace) {
      isLoggingIn = false;
      notifyListeners();

      return false;
    });
  }
}
