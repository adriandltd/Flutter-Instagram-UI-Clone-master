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

class InstaNewPost extends StatefulWidget {
  InstaNewPost();

  _InstaNewPost createState() => new _InstaNewPost();
}

class _InstaNewPost extends State<InstaNewPost> {
  var captionCtrl = TextEditingController();
  File _image;

  Future<Response> upload(TextEditingController caption) async {
    FormData formData = new FormData.from(
        {
        "caption": caption.text, 
        "image": new UploadFileInfo(_image, _image.path)
        });
    var response = await Dio().post(
      "http://serene-beach-48273.herokuapp.com/api/v1/posts",
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
        title: RichText(
          text: TextSpan(style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),children: <TextSpan>[ 
          TextSpan(
          text: "Create a Post",
          )]
        )),
        actions: <Widget>[
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top:30, bottom:30),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Please select your image:"),
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
          Padding(padding: EdgeInsets.only(top:30, bottom:30),),              
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Please type a caption below:"),
            ],
          ),          
          Padding(padding: EdgeInsets.all(5),),              
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 325,
                  child: TextField(
                    controller: captionCtrl,
                    decoration: InputDecoration(
                        hintText: "Caption",
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
                  child: Text("Post"),
                  onPressed: () {
                    upload(captionCtrl);
                    Navigator.of(context).pop();
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
