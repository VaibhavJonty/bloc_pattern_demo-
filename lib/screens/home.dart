import 'package:flutter/material.dart';
import 'package:pet/bloc/auth_bloc.dart';
import 'package:pet/helper/res.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/screens/add_event.dart';
import 'package:pet/screens/add_pet_name.dart';
import 'package:pet/screens/add_pet_photo.dart';
import 'package:pet/screens/login.dart';
import 'package:pet/screens/show_event.dart';
import 'package:pet/screens/show_pets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Destination {
  const Destination(this.index, this.title, this.icon, this.color);

  final int index;
  final String title;
  final String icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination(0, 'Home', "assets/images/home.png", Colors.teal),
  Destination(1, 'Business', "assets/images/family.png", Colors.cyan),
];

class _HomeState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.subdirectory_arrow_right),
            onPressed: () async {
              authBloc.closeSession();

              await Injector.prefs.clear();
              Injector.accessToken = null;
              Injector.refreshToken = null;

//              Navigator.pushAndRemoveUntil(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => LoginPage(),
//                  ),
//                  ModalRoute.withName("/home"));
            },
          ),
        ],
        // action button
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                EventPage(),
                AddEvent(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: ColorRes.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text('Show event'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Event'),
          ),
        ],
      ),
    );
  }
}
