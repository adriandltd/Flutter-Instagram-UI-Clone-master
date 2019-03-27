import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InstaList extends StatefulWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaList(this.posts, this.myPosts);
  @override
  _InstaList createState() => new _InstaList(this.posts, this.myPosts);
}

class _InstaList extends State<InstaList> {
  List<dynamic> posts;
  List<dynamic> myPosts;
  _InstaList(this.posts, this.myPosts);

  checkValidImage(index) {
    try {
      return Image.network(posts[index]["image_url"]);
    } catch (e) {
      return Image.asset('assets/images/empty-photo.jpg');
    }
  }

  checkValidProfileImage(index) {
    try {
      return NetworkImage(posts[index]["user_profile_image_url"]);
    } catch (e) {
      return AssetImage('assets/images/empty-profile.png');
    }
  }

  checkValidCurrentImage(index) {
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

  likeButtonTriggerPost(index) {
    var token = MyLoginPage().login();
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/posts/$index/likes";
    http.post(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    likeButtonCheck(index);
  }

  likeButtonCheck(index) {
    if (posts[index]["liked"] == false)
      return Icon(FontAwesomeIcons.heart);
    else
      return Icon(FontAwesomeIcons.solidHeart, color: Colors.red,);
  }

  checkNumLikes(index) {
    if (posts[index]["likes_count"] == 0)
      return " ";
    else if (posts[index]["likes_count"] == 1)
      return (posts[index]["likes_count"].toString() + " like");
    else
      return (posts[index]["likes_count"].toString() + " likes");
  }

  timeStamper(index) {
    final currentDate = DateTime.now();
    final postDate = DateTime.parse(posts[index]["created_at"]);
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

  @override
  Widget build(BuildContext context) {
    //var deviceSize = MediaQuery.of(context).size;
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: refreshList,
      key: refreshKey,
      child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: checkValidProfileImage(index)),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            posts[index]["user_email"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
                Flexible(fit: FlexFit.loose, child: checkValidImage(index)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: likeButtonCheck(index),
                              onPressed: likeButtonTriggerPost(index)),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            FontAwesomeIcons.comment,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Icon(
                            FontAwesomeIcons.paperPlane,
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(FontAwesomeIcons.bookmark))
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      checkNumLikes(index),
                      style: TextStyle(fontSize: 15.0),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: posts[index]["user_email"] + " ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: posts[index]["caption"]),
                        ]))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: checkValidCurrentProfileImage(index)),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add a comment...",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(timeStamper(index),
                      style: TextStyle(color: Colors.grey)),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 5.0))
              ],
            );
          },
        ));
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new InstaList(posts,myPosts);
    });

    return null;
  }
}
