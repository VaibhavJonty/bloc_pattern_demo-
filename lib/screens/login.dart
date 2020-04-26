import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/bloc/login_bloc.dart';
import 'package:pet/helper/res.dart';
import 'package:pet/screens/register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorRes.blue,
        child: Center(
          child: SizedBox(
            height: 350,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.all(20),
              elevation: 5,
              color: ColorRes.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  emailField(bloc),
                  passwordField(bloc),
                  Container(margin: EdgeInsets.only(top: 25.0)),
                  submitButton(bloc),
                  InkResponse(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Don't have account?",style: TextStyle(color: Colors.blue),),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                  ),
                  loadingIndicator(bloc)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget loadingIndicator(LoginBloc bloc) => StreamBuilder<bool>(
      stream: bloc.loading,
      builder: (context, snap) {
        return Container(
          child:
              (snap.hasData && snap.data) ? CircularProgressIndicator() : null,
        );
      },
    );

Widget emailField(LoginBloc bloc) => StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, snap) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: bloc.changeEmail,
//          decoration: InputDecoration(
//              labelText: "Username", hintText: "abc123", errorText: snap.error),
//        );
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
                errorText: snap.error,
                labelText: "Username",
                contentPadding: EdgeInsets.all(15),
                hintText: "abc123",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.person),
                ),
              )),
        );
      },
    );

Widget passwordField(LoginBloc bloc) => StreamBuilder<String>(
    stream: bloc.password,
    builder: (context, snap) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          obscureText: true,
          onChanged: bloc.changePassword,
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
              errorText: snap.error,
              labelText: "Password",
              contentPadding: EdgeInsets.all(15),
              hintText: "Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.lock),
              ),
            ),
        ),
      );
    });

Widget submitButton(LoginBloc bloc) => StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return RaisedButton(
          disabledColor: Colors.blue,
          shape: RoundedRectangleBorder(

              borderRadius: new BorderRadius.circular(18.0),

              side: BorderSide(color: Colors.blue)
          ),
          onPressed: (!snap.hasData) ? null : bloc.submit,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,8,16,8),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
          color: Colors.blue,
        );
      },
    );
