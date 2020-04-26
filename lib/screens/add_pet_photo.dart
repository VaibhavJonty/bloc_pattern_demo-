import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pet/screens/add_pet_name.dart';

import '../helper/res.dart';
import '../helper/utils.dart';

class AddPetPhoto extends StatefulWidget {
  @override
  _AddPetPhotoState createState() => _AddPetPhotoState();
}

class _AddPetPhotoState extends State<AddPetPhoto> {
  String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Pet"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            InkResponse(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 30, left: 30, right: 10, bottom: 10),
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                            image: imageShow(), fit: BoxFit.cover)),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 20,
                    child: InkResponse(
                      child: Icon(Icons.add_a_photo),
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
                onTap: () {
                  if (imagePath == null || imagePath.isEmpty) {
                    Utils.showToast("Please select photo");
                  } else {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => AddPetName(
//                                photo: imagePath,
//                              )),
//                    );
                  }
                },
              ),
            )
          ],

//        ),
        ),
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
