import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/bloc/get_events_bloc.dart';
import 'package:pet/bloc/get_pet_bloc.dart';
import 'package:pet/helper/res.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/get_event.dart';
import 'package:pet/model/get_pet.dart';

import 'add_pet_name.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<PetEvent> arrEvents = List();

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: getPetBloc.getPetDataOb,
              builder: (context, AsyncSnapshot<List<PetData>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Utils.showShimmerProfile();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isNotEmpty)
                      return showPet(snapshot?.data);
                    else
                      return   RaisedButton.icon(
                        label: Text("Add Pet"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPetName()),
                          );
                        },
                        icon: Icon(Icons.add),
                      );
                  }
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Container();
              }),
          showItems(context)
        ],
      ),
    );
  }

  showItems(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: getEventBloc.getEventsOb,
          builder: (context, AsyncSnapshot<List<PetEvent>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Utils.showShimmer();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData)
                return showData(snapshot?.data);
              else
                Container();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Container();
          }),
    );
  }

  showData(List<PetEvent> data) {
    arrEvents = data;

    return ListView.builder(
      itemCount: arrEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return showItem(arrEvents[index]);
      },
    );
  }

  imageShow(String petImage) {
    return NetworkImage(petImage);
  }

  showItem(PetEvent petEvent) {
    return InkResponse(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: ColorRes.greyText, blurRadius: 1.5)],
          color: ColorRes.white,
        ),
        margin: EdgeInsets.only(
            left: Utils.getDeviceWidth(context) / 15,
            right: Utils.getDeviceWidth(context) / 15,
            top: Utils.getDeviceWidth(context) / 25),
        child: ListTile(
          leading: petEvent.eventImage != null
              ? Image(
                  image: NetworkImage(petEvent.eventImage),
                )
              : FlutterLogo(size: 72.0),
          title: Text(petEvent.comment ?? ""),
          subtitle: Text(petEvent.comment ?? ""),
          isThreeLine: true,
        ),
      ),
    );
  }

  void getData() async {
    await getPetBloc.getPet();
    await getEventBloc.getEvents();
  }

  Widget showPet(List<PetData> data) {
    return data.isNotEmpty
        ? Column(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 30, left: 30, right: 10, bottom: 10),
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageShow(data[data.length - 1].petImage),
                        fit: BoxFit.cover)),
              ),
              Text(data[data.length - 1].name),
            ],
          )
        : Container();
  }
}
