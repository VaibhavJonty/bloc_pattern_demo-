import 'package:pet/helper/prefkeys.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:rxdart/rxdart.dart';

class AuthorizationBloc {
  String _tokenString = "";
  final PublishSubject _isSessionValid = PublishSubject<bool>();

  Observable<bool> get isSessionValid => _isSessionValid.stream;

  void dispose() {
    _isSessionValid.close();
  }

  void restoreSession() async {
    _tokenString = Injector.prefs.getString(PrefKeys.accessToken);
    Injector.accessToken = _tokenString;
    print("token   " + _tokenString.toString());
    if (_tokenString != null && _tokenString.length > 0) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  void openSession(String accessToken, String refreshToken) async {
    if (accessToken != null) {
      await Injector.prefs.setString(PrefKeys.accessToken, accessToken);
      Injector.accessToken = accessToken;
    }
    if (refreshToken != null) {
      await Injector.prefs.setString(PrefKeys.refreshToken, refreshToken);
      Injector.refreshToken = refreshToken;
    }
    _tokenString = accessToken;
    _isSessionValid.sink.add(true);
  }

  void closeSession() async {
    await Injector.prefs.clear();
    Injector.accessToken = null;
    Injector.refreshToken = null;
    Injector.petData = null;
    _isSessionValid.sink.add(false);
  }
}

final authBloc = AuthorizationBloc();
