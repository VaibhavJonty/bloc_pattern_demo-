import 'package:flutter/material.dart';
import 'package:pet/screens/add_pet_name.dart';
import 'package:pet/screens/add_pet_photo.dart';
import 'package:pet/screens/home.dart';
import 'package:pet/screens/login.dart';
import 'package:pet/screens/register.dart';

import 'bloc/auth_bloc.dart';
import 'injection/dependency_injection.dart';

void main() => setupLocator();

Future setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 10)).then((v) {
      authBloc.restoreSession();
    });

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: <String, WidgetBuilder>{
          '/addpet': (BuildContext context) => AddPetName(),
          '/register': (BuildContext context) => RegisterPage(),
          '/home': (BuildContext context) => HomePage(),
        },
        home: createContent());
  }

  createContent() {
    return StreamBuilder<bool>(
        stream: authBloc.isSessionValid,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return HomePage();
          }
          return LoginPage();
        });
  }
}
