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

class InstaEditPost extends StatefulWidget {
  int postid;
  InstaEditPost(this.postid);

  _InstaEditPost createState() => new _InstaEditPost(this.postid);
}

class _InstaEditPost extends State<InstaEditPost> {
  int postid;
  var captionCtrl = TextEditingController();

  _InstaEditPost(this.postid);

  Future<Response> upload(TextEditingController caption, postid) async {
    FormData formData = new FormData.from(
        {
        "caption": caption.text, 
        });
    var response = await Dio().patch(
      "http://serene-beach-48273.herokuapp.com/api/v1/posts/$postid",
      data: formData,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"},
      ),
    );
    return response;
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
          text: "Edit Post",
          )]
        )),
        actions: <Widget>[
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top:30, bottom:30),),
          Padding(padding: EdgeInsets.all(10),),
          Padding(padding: EdgeInsets.only(top:30, bottom:30),),              
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Please type your new caption below:"),
            ],
          ),          
          Padding(padding: EdgeInsets.all(10),),              
          Row(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 325,
                  child: TextField(
                    controller: captionCtrl,
                    decoration: InputDecoration(
                        hintText: "New caption...",
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
                  child: Text("Edit Caption"),
                  onPressed: () {
                    upload(captionCtrl,postid);
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
