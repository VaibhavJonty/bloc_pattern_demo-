import 'dart:async';
import 'dart:convert';

import 'package:pet/bloc/auth_bloc.dart';
import 'package:pet/helper/prefkeys.dart';
import 'package:pet/model/get_pet.dart';
import 'package:pet/model/login.dart';
import 'package:pet/model/register.dart';
import 'package:pet/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Injector {
  static SharedPreferences prefs;

  static String accessToken;
  static String refreshToken;

  static UserData userDataMain;
  static SignInResponse signInResponse;
  static PetData petData;

  static StreamController<String> streamController;

  static getInstance() async {
    prefs = await SharedPreferences.getInstance();

    streamController = StreamController.broadcast();
    getUserData();

    authBloc.restoreSession();

  }

  static updateAuthData(String accessToken) async {
    await Injector.prefs.setString(PrefKeys.accessToken, accessToken);

    accessToken = accessToken;
  }

  static getUserData() {
    if (prefs.getString(PrefKeys.petData) != null)
      petData = PetData.fromJson(jsonDecode(prefs.getString(PrefKeys.petData)));
  }
}
