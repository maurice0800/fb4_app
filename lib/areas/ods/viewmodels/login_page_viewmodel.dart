import 'package:fb4_app/areas/ods/repositories/ods_repository.dart';
import 'package:fb4_app/areas/ods/services/ods_authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPageViewModel extends ChangeNotifier {
  bool _isSaveCredentialsChecked = false;
  bool isLoggingIn = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  set isSaveCredentialsChecked(bool value) {
    _isSaveCredentialsChecked = value;
    notifyListeners();
  }

  bool get isSaveCredentialsChecked {
    return _isSaveCredentialsChecked;
  }

  Future<bool?> login() {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      return Future.value(false);
    }

    isLoggingIn = true;
    notifyListeners();

    return getAuthToken(username, password).then((token) {
      if (token.isNotEmpty) {
        if (isSaveCredentialsChecked) {
          const FlutterSecureStorage()
              .write(key: 'odsUsername', value: username);
          const FlutterSecureStorage()
              .write(key: 'odsPassword', value: password);
        }

        usernameController.text = "";
        passwordController.text = "";

        OdsRepository.cachedToken = token;
        isLoggingIn = false;
        return true;
      }
    }).onError((error, stackTrace) {
      isLoggingIn = false;
      notifyListeners();

      return false;
    });
  }
}
