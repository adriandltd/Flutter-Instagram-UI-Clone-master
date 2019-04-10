import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:flutter_insta_clone/insta_home.dart';
import 'package:flutter_insta_clone/insta_list.dart';
import 'package:flutter_insta_clone/insta_comments.dart';
import 'package:flutter_insta_clone/insta_editprofile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var myid;

class InstaMyProfile extends StatefulWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaMyProfile(this.myPosts);

  _InstaMyProfile createState() => new _InstaMyProfile(this.posts, this.myPosts);
}

class _InstaMyProfile extends State<InstaMyProfile> {
  List<dynamic> posts;
  List<dynamic> myPosts;
  Map<String, dynamic> myAccount;
  _InstaMyProfile(this.posts,this.myPosts);

  int postsCount;

  @override
  void initState() {
    super.initState();
    getMyAccount(context);
  }

  Future<Map<String, dynamic>> getMyAccount(token) async {
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/my_account";

    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
    var _myAccount = jsonDecode(response.body);
    setState(() {
      myAccount = _myAccount;
    });

    var id = _myAccount["id"];

    myid = id;
    
    print("Response status: ${response.statusCode}");
    return jsonDecode(response.body);
  }

     Widget futureWidget() {
    return new FutureBuilder<Map<String,dynamic>>(
      future: getMyAccount(savedToken),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(child: InstaList(posts, myPosts, null,false, true));

        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }

        return new CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700),children: <TextSpan>[ 
          TextSpan(
          text: myAccount["email"],
          )]
        )),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          NetworkImage(myAccount["profile_image_url"]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                //  buildProfileFollowButton(user)
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: MaterialButton(
                                  child: Text("Edit Profile"),
                                  onPressed: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => InstaEditProfile()));

                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      myAccount["email"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(myAccount["bio"]),
                ),
              ],
            ),
          ),
          Divider(),
          futureWidget(),            
        ])
  );}
}
