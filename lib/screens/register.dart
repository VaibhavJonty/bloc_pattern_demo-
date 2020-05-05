import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/bloc/auth_bloc.dart';
import 'package:pet/bloc/register_bloc.dart';
import 'package:pet/helper/constant.dart';
import 'package:pet/helper/res.dart';

import 'package:pet/helper/utils.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/err_response.dart';
import 'package:pet/model/refresh.dart';
import 'package:pet/model/register.dart';
import 'package:pet/screens/add_pet_name.dart';
import 'package:pet/screens/add_pet_photo.dart';
import 'package:pet/webapi/web_api.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
//username Widget
  Widget usernameField() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: usernameController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter username';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: ColorRes.lightBlue,
            labelText: "Username",
            hintText: "abc123",
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.person),
            ),
          ),
        ),
      );

  Widget emailField() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          validator: (value) {
            if (value.isEmpty || !value.contains("@")) {
              return 'Please enter valid email';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: ColorRes.lightBlue,
            labelText: "Email address",
            hintText: "you@example.com",
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.email),
            ),
          ),
        ),
      );

  Widget passwordField() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          obscureText: true,
          controller: passwordController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: ColorRes.lightBlue,
            labelText: "Password",
            hintText: "Password",
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.lock),
            ),
          ),
        ),
      );

  Widget password2Field() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          obscureText: true,
          controller: password2Controller,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter password';
            } else if (passwordController.text != password2Controller.text)
              return "Passowrd doesn't match with previous one.";
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: ColorRes.lightBlue,
            labelText: "Confirm Password",
            hintText: "Confirm Password",
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.lock),
            ),
          ),
        ),
      );

  Widget submitButton() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.blue)),
          onPressed: () {
            validateData();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
          color: Colors.blue,
        ),
  );

  Widget loadingIndicator() => isLoading
      ? Container(
          child: CircularProgressIndicator(),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: SizedBox(
            height: 500,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.all(20),
              elevation: 5,
              color: ColorRes.white,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          usernameField(),
                          emailField(),
                          passwordField(),
                          password2Field(),
                          submitButton(),
                          InkResponse(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Have an account ? Login",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
//
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: loadingIndicator(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateData() async {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a Snackbar.
      setState(() {
        isLoading = true;
      });

      await WebApi()
          .callAPI(
              Const.post,
              WebApi.rqRegister,
              SignUpRequest(
                      username: usernameController.text,
                      password: passwordController.text,
                      password2: password2Controller.text,
                      email: emailController.text)
                  .toJson())
          .then((data) async {
        SignUpResponse signUpResponse = SignUpResponse.fromJson(data);

        RefreshTokenRequest refreshTokenRequest =
            RefreshTokenRequest(refresh: signUpResponse.refresh);

        print(jsonEncode(signUpResponse.toJson()));

        if (signUpResponse != null)
          {
            print('signUpResponse.refresh '+signUpResponse.refresh);
            refreshToken(refreshTokenRequest);
          }
          else {
            Utils.showToast('Something went wrong, please try again!');
        }


      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    }

//
  }

  void refreshToken(RefreshTokenRequest refreshTokenRequest) async {
    Dio dio = Dio();

    BaseOptions options = new BaseOptions(
        baseUrl: WebApi.baseUrl, connectTimeout: 20000, receiveTimeout: 3000);

    dio.options = options;

    RefreshTokenResponse refreshTokenResponse;
    await dio
        .post(WebApi.rqRefreshToken,
            data: json.encode(refreshTokenRequest.toJson()))
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        refreshTokenResponse = RefreshTokenResponse.fromJson(response.data);

        setState(() {
          isLoading = false;
        });

        if (refreshTokenResponse != null) {
          print('refreshTokenResponse.access' + refreshTokenResponse.access);
          AuthorizationBloc authorizationBloc = AuthorizationBloc();
          authorizationBloc.openSession(
              refreshTokenRequest.refresh, refreshTokenResponse.access);

          navigateToHome(context);
        }
      }
    }).catchError((e) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
      Utils.showToast(errorResponse.detail);
      setState(() {
        isLoading = false;
      });
    });
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AddPetName(),
        ),
        ModalRoute.withName("/register"));
  }
}
