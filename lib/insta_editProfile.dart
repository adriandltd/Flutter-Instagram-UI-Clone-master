import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:flutter_insta_clone/insta_login.dart';

class InstaEditProfile extends StatefulWidget {
  InstaEditProfile();

  _InstaEditProfile createState() => new _InstaEditProfile();
}

class _InstaEditProfile extends State<InstaEditProfile> {
  var bioCtrl = TextEditingController();
 File _image;

  Future<Response> upload(TextEditingController bio) async {
    FormData formData = new FormData.from(
        {
        "bio": bio.text, 
        });
    var response = await Dio().patch("http://serene-beach-48273.herokuapp.com/api/v1/my_account?$bio",
      data: formData,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"},
      ),
    );
    return response;
  }

   Future<Response> uploadImage() async {
    FormData formData = new FormData.from(
        {
          "image": new UploadFileInfo(_image, _image.path)
        });
    var response = await Dio().patch("http://serene-beach-48273.herokuapp.com/api/v1/my_account/profile_image",
      data: formData,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"},
      ),
    );
    return response;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
    _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff8faf8),
        centerTitle: true,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Edit Profile", textAlign: TextAlign.left),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.send),
          )
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top:30, bottom:30),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Please select your new Profile image:"),
            ],
          ),
          Padding(padding: EdgeInsets.all(10),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                tooltip: "Press me to add an image from your camera roll",
                icon: Icon(Icons.add_a_photo),
                onPressed: () { 
                  getImage();
                },
              ),
            ],
          ),          
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: MaterialButton(
                  child: Text("Update Profile Picture"),
                  onPressed: () {
                    uploadImage();
                  },
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top:30, bottom:30),),              
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Please type a bio below:"),
            ],
          ),          
          Padding(padding: EdgeInsets.all(5),),              
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 325,
                  child: TextField(
                    controller: bioCtrl,
                    decoration: InputDecoration(
                        hintText: "Bio",
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()),
                    textCapitalization: TextCapitalization.none,
                    autocorrect: true,
                  )),
            ],
          ),
          Padding(padding: EdgeInsets.only(top:10, bottom:10),),
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: MaterialButton(
                  child: Text("Update Bio"),
                  onPressed: () {
                    upload(bioCtrl);
                  },
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top:10, bottom:10),),
        ]),
      ),
    );
  }
}
