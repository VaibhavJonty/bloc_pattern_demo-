import 'dart:async';

import 'package:pet/bloc/validator.dart';
import 'package:pet/helper/constant.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/register.dart';
import 'package:pet/webapi/web_api.dart';
import 'package:rxdart/rxdart.dart';

import 'auth_bloc.dart';

class RegisterBloc extends Validators {
  final BehaviorSubject _usernameController = BehaviorSubject<String>();
  final BehaviorSubject _emailController = BehaviorSubject<String>();
  final BehaviorSubject _passwordController = BehaviorSubject<String>();
  final BehaviorSubject _password2Controller = BehaviorSubject<String>();
  final PublishSubject _loadingData = PublishSubject<bool>();

  Function(String) get changeUsername => _usernameController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Function(String) get changePassword2 => _passwordController.sink.add;

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<String> get username =>
      _usernameController.stream.transform(validateUsernmae);

  Stream<String> get password2 =>
      _password2Controller.stream.transform(validatePassword);

  Stream<bool> get submitValid => Observable.combineLatest3(
      email, password, username, (email, password, username) => true);

  Observable<bool> get loading => _loadingData.stream;

  void submit() {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    final validUsername = _usernameController.value;
    _loadingData.sink.add(true);
    register(validEmail, validPassword, validUsername);
  }

  register(String email, String password, String userName) async {
    try {
      var data = await WebApi().callAPI(
          Const.post,
          WebApi.rqRegister,
          SignUpRequest(
                  username: userName,
                  password: password,
                  password2: password,
                  email: email)
              .toJson());
      _loadingData.sink.add(false);
      SignUpResponse signUpResponse = SignUpResponse.fromJson(data);

      await WebApi().refreshToken(Const.post, WebApi.rqRefreshToken,
          {'refresh': Injector.refreshToken}).then((data){

      });
    } catch (e) {
      print(e);
      _loadingData.sink.add(false);
    }

    _loadingData.sink.add(false);
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _usernameController.close();
    _password2Controller.close();
    _loadingData.close();
  }
}
