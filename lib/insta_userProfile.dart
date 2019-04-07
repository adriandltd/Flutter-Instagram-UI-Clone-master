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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class InstaUserProfile extends StatefulWidget {
  int userid;
  Map<String, dynamic> userAccount;
  InstaUserProfile(this.userid);

  _InstaUserProfile createState() => new _InstaUserProfile(this.userid);
}

class _InstaUserProfile extends State<InstaUserProfile> {
  int userid;
  Map<String, dynamic> userAccount;
  _InstaUserProfile(this.userid);
  var userPosts;

  int postsCount;

  @override
  void initState() {
    super.initState();
    getUserAccount();
    getUserPosts();
  }

  Future<Map<String, dynamic>> getUserAccount() async {
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/users/$userid";

    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
    var _userAccount = jsonDecode(response.body);
    setState(() {
      userAccount = _userAccount;
    });
  }

  getUserPosts()async{
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/users/$userid/posts";

    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
    var _userPosts = jsonDecode(response.body);
    setState(() {
      userPosts = _userPosts;
    });
    print("Response status: ${response.statusCode}");
    print(userPosts.toString());
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userAccount["email"],
          style: const TextStyle(color: Colors.black),
        ),
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
                          NetworkImage(userAccount["profile_image_url"]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                //  buildProfileFollowButton(user)
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      userAccount["email"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(userAccount["bio"]),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(child: InstaList(userPosts, userPosts,true)),
          Divider(height: 0.0),
        ],
      ),
    );
  }
}
