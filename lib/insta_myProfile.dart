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

class InstaMyProfile extends StatefulWidget {
  List<dynamic> myPosts;
  InstaMyProfile(this.myPosts);

  _InstaMyProfile createState() => new _InstaMyProfile(this.myPosts);
}

class _InstaMyProfile extends State<InstaMyProfile> {
  List<dynamic> myPosts;
  Map<String, dynamic> myAccount;
  _InstaMyProfile(this.myPosts);

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
    print("Response status: ${response.statusCode}");
    return jsonDecode(response.body);
  }

  refreshData(context) async {
    var newmyPosts = await MyLoginPage().getMyPosts(savedToken);

    setState(() {
      this.myPosts = newmyPosts;
      _InstaMyProfile(this.myPosts).build(context);
    });
  }

  checkValidProfileImage(index) {
    try {
      return NetworkImage(myPosts[index]["user_profile_image_url"]);
    } catch (e) {
      return AssetImage('assets/images/empty-profile.png');
    }
  }

  checkValidImage(index) {
    try {
      return Image.network(myPosts[index]["image_url"]);
    } catch (e) {
      return Image.asset('assets/images/empty-photo.jpg');
    }
  }

  checkValidCurrentProfileImage(index) {
    try {
      return NetworkImage(myPosts[index]["user_profile_image_url"]);
    } catch (e) {
      return AssetImage('assets/images/empty-profile.png');
    }
  }

  likeButtonCheck(index) {
    if (myPosts[index]["liked"] == false)
      return Icon(
        FontAwesomeIcons.heart,
        color: Colors.black,
      );
    else
      return Icon(
        FontAwesomeIcons.solidHeart,
        color: Colors.red,
      );
  }

  Future<void> likeButtonTriggerPost(index, id) async {
    if (myPosts[index]["liked"] == false) {
      var token = savedToken;
      var url =
          "https://serene-beach-48273.herokuapp.com/api/v1/posts/$id/likes";
      print("liked post " + id.toString());
      var request = await http.post(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      print("Response status: ${request.statusCode}");
    } else {
      var token = savedToken;
      var url =
          "https://serene-beach-48273.herokuapp.com/api/v1/posts/$id/likes";
      print("unliked post " + id.toString());
      var request = await http.delete(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      print("Response status: ${request.statusCode}");
    }
  }

  checkNumLikes(index) {
    if (myPosts[index]["likes_count"] == 0)
      return " ";
    else if (myPosts[index]["likes_count"] == 1)
      return (myPosts[index]["likes_count"].toString() + " like");
    else
      return (myPosts[index]["likes_count"].toString() + " likes");
  }

  checkNumComments(index) {
    if (myPosts[index]["comments_count"] == 0)
      return " ";
    else if (myPosts[index]["comments_count"] == 1)
      return ("View " +
          myPosts[index]["comments_count"].toString() +
          " comment");
    else
      return ("View all " +
          myPosts[index]["comments_count"].toString() +
          " comments");
  }

  timeStamper(index) {
    final currentDate = DateTime.now();
    final postDate = DateTime.parse(myPosts[index]["created_at"]);
    final difference = currentDate.difference(postDate);
    String inHours = difference.inHours.toString();
    String inMin = difference.inMinutes.toString();
    String inDays = difference.inDays.toString();
    if (difference.inMinutes < 60) {
      if (difference.inMinutes <= 1) return inMin + " minute ago";
      return inMin + " minutes ago";
    } else if (difference.inHours < 24) {
      if (difference.inHours <= 1) return inHours + " hour ago";
      return inHours + " hours ago";
    } else {
      if (difference.inDays <= 1) return inDays + " day ago";
      return inDays + " days ago";
    }
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    refreshData(context);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          myAccount["email"],
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
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
          //   RefreshIndicator(
          // color: Colors.black,
          // onRefresh: refreshList,
          // key: refreshKey,
          // child: ListView.builder(
          //   itemCount: postsCount = myPosts.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 7.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Row(
          //                 children: <Widget>[
          //                   Container(
          //                     height: 40.0,
          //                     width: 40.0,
          //                     decoration: BoxDecoration(
          //                       shape: BoxShape.circle,
          //                       image: DecorationImage(
          //                           fit: BoxFit.fill,
          //                           image: checkValidProfileImage(index)),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 10.0,
          //                   ),
          //                   InkWell(child: Text(
          //                     myPosts[index]["user_email"],
          //                     style: TextStyle(fontWeight: FontWeight.bold),

          //                   ),onTap: () {
          //                     //this is the video I was looking at: https://www.youtube.com/watch?v=EwHMSxSWIvQ
          //                     var id = myPosts[index]["id"];
          //                   },),
          //                 ],
          //               ),
          //               IconButton(
          //                 icon: Icon(Icons.more_vert),
          //                 onPressed: null,
          //               )
          //             ],
          //           ),
          //         ),
          //         Flexible(fit: FlexFit.loose, child: checkValidImage(index)),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 5.25),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: <Widget>[
          //                   IconButton(
          //                       icon: likeButtonCheck(index),
          //                       onPressed: () {
          //                         var id = myPosts[index]["id"];
          //                         likeButtonTriggerPost(index, id);
          //                         refreshData(context);
          //                       }),
          //                   SizedBox(
          //                     width: 8.0,
          //                   ),
          //                   Icon(
          //                     FontAwesomeIcons.comment,
          //                   ),
          //                   SizedBox(
          //                     width: 16.0,
          //                   ),
          //                   IconButton(
          //                   onPressed: (){

          //                   },
          //                   icon: Icon(FontAwesomeIcons.paperPlane,),
          //                   )
          //                 ],
          //               ),
          //               Padding(
          //                   padding: EdgeInsets.only(right: 8.0),
          //                   child: Icon(FontAwesomeIcons.bookmark))
          //             ],
          //           ),
          //         ),
          //         Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //             child: Text(
          //               checkNumLikes(index),
          //               style: TextStyle(fontSize: 15.0),
          //             )),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 3.0),
          //         ),
          //         Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //             child: RichText(
          //                 text: TextSpan(
          //                     style: TextStyle(
          //                       fontSize: 15.0,
          //                       color: Colors.black,
          //                     ),
          //                     children: <TextSpan>[
          //                   TextSpan(
          //                       text: myPosts[index]["user_email"] + " ",
          //                       style: TextStyle(fontWeight: FontWeight.bold)),
          //                   TextSpan(text: myPosts[index]["caption"]),
          //                 ]))),
          //         Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 16.0, vertical: 5),
          //             child: GestureDetector(
          //               onTap: (){
          //                 refreshData(context);
          //                 var id = myPosts[index]["id"];
          //                 Navigator.push(context, MaterialPageRoute(builder: (context) => InstaComments(myPosts, index, id)));
          //                 },
          //               child: Text(checkNumComments(index), style: TextStyle(color: Colors.grey, fontSize: 14)),
          //             )),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: <Widget>[
          //               Container(
          //                 height: 40.0,
          //                 width: 40.0,
          //                 decoration: BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   image: DecorationImage(
          //                       fit: BoxFit.fill,
          //                       image: checkValidCurrentProfileImage(index)),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 10.0,
          //               ),
          //             ],
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //           child: Text(timeStamper(index),
          //               style: TextStyle(color: Colors.grey)),
          //         ),
          //         Padding(padding: const EdgeInsets.symmetric(vertical: 5.0))
          //       ],
          //     );
          //   },
          // ),),
          Divider(height: 0.0),
          // buildUserPosts(),
        ],
      ),
    );
  }
}
