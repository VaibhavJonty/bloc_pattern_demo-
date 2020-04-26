import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/bloc/get_events_bloc.dart';
import 'package:pet/helper/res.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/model/get_event.dart';
import 'package:pet/webapi/web_api.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String imagePath;
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  Widget loadingIndicator() => isLoading
      ? Container(
          child: CircularProgressIndicator(),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                InkResponse(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 30, right: 10, bottom: 10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageShow(), fit: BoxFit.cover)),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 20,
                        child: InkResponse(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 25,
                          ),
                          onTap: () {
                            getImage();
                          },
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    getImage();
                  },
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Comment",
                    hintText: "",
                  ),
                ),
                Container(
                  height: 35,
                  width: 100,
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: ColorRes.black,
                  ),
                  child: InkResponse(
                    child: Text(
                      "NEXT",
                      style: TextStyle(color: ColorRes.white),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      if (imagePath == null || imagePath.isEmpty) {
                        Utils.showToast("Please select photo");
                      } else {
                        if (nameController.value != null &&
                            nameController.value.text.toString().isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          await WebApi()
                              .addEventData(WebApi.addEvent, File(imagePath),
                                  nameController.value.text.toString())
                              .then((data) async {
                            if (data != null) {
                              PetEvent petEvent = PetEvent.fromJson(data);
                              getEventBloc.getEvents();
                              Utils.showToast("Event added successfully");
                              nameController.text = "";
                              imagePath = "";
                              setState(() { isLoading = false;});
                            }
                          }).catchError((e) {
                            Utils.showToast(e);
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ),
          loadingIndicator()
        ],
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath = image.path.toString();
    }
    setState(() {});
  }

  imageShow() {
    return imagePath != null && imagePath.isNotEmpty
        ? imagePath.contains("http")
            ? NetworkImage(imagePath)
            : FileImage(File(imagePath))
        : AssetImage(Utils.getAssetsImg("profile"));
  }
}
