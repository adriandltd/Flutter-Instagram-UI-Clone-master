import 'package:flutter_insta_clone/insta_comments.dart';
import 'package:flutter_insta_clone/insta_userProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:flutter_insta_clone/insta_myProfile.dart';
import 'package:flutter_insta_clone/insta_editPost.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class InstaList extends StatefulWidget {
  List<dynamic> allposts;
  List<dynamic> myPosts;
  List<dynamic> userPosts;
  bool isUserPost;
  bool isMyPost;
  InstaList(this.allposts, this.myPosts, this.userPosts, this.isUserPost,
      this.isMyPost);
  @override
  _InstaList createState() {
    if (isUserPost == true && isMyPost == false) {
      return new _InstaList(this.userPosts, this.allposts, this.myPosts,
          this.userPosts, true, false);
    } else if (isUserPost == false && isMyPost == true) {
      return new _InstaList(this.myPosts, this.allposts, this.myPosts,
          this.userPosts, false, true);
    } else if (isUserPost == false && isMyPost == false) {
      return new _InstaList(this.allposts, this.allposts, this.myPosts,
          this.userPosts, false, false);
    }
  }
}

class _InstaList extends State<InstaList> {
  List<dynamic> posts;
  List<dynamic> allposts;
  List<dynamic> myPosts;
  List<dynamic> userPosts;
  bool isUserPost;
  bool isMyPost;
  int postsCount;
  int userid;
  Map<String, dynamic> userAccount;

  @override
  void initState() {
    super.initState();
    refreshData(context);
  }

  _InstaList(this.posts, this.allposts, this.myPosts, this.userPosts,
      this.isUserPost, this.isMyPost);

  checkValidImage(index) {
    try {
      var response = ((posts[index]["image_url"]).toString());
      return response;
    } catch (e) {
      return (Image.asset('assets/images/empty-photo.jpg'));
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

  Future<void> likeButtonTriggerPost(index, id) async {
    if (posts[index]["liked"] == false) {
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

  Future<List<dynamic>> getUserPosts(index, id) async {
    var token = savedToken;
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/users/$id/posts";

    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    //print("Response status: ${response.statusCode}");
    return jsonDecode(response.body);
  }

  refreshData(context) async {
    var newPosts = await MyLoginPage().getPosts(savedToken);
    var newmyPosts = await MyLoginPage().getMyPosts(savedToken);
    setState(() {
      if (isUserPost == false && isMyPost == false) {
        this.posts = newPosts;
        this.myPosts = newmyPosts;
        _InstaList(this.allposts, this.allposts, this.myPosts, this.userPosts,
                false, false)
            .build(context);
      } else if (isUserPost == true && isMyPost == false) {
        this.posts = userPosts;
        this.myPosts = newmyPosts;
        _InstaList(this.userPosts, this.allposts, this.myPosts, this.userPosts,
                true, false)
            .build(context);
      } else if (isUserPost == false && isMyPost == true) {
        this.posts = newmyPosts;
        this.myPosts = newmyPosts;
        _InstaList(this.myPosts, this.allposts, this.myPosts, this.userPosts,
                true, false)
            .build(context);
      }
    });
  }

  likeButtonCheck(index) {
    if (posts[index]["liked"] == false)
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

  postComment(index) {}

  checkNumLikes(index) {
    if (posts[index]["likes_count"] == 0)
      return null;
    else if (posts[index]["likes_count"] == 1)
      return Text((posts[index]["likes_count"].toString() + " like"),
          style: TextStyle(fontSize: 15.0));
    else
      return Text((posts[index]["likes_count"].toString() + " likes"),
          style: TextStyle(fontSize: 15.0));
  }

  checkNumComments(index) {
    if (posts[index]["comments_count"] == 0)
      return " ";
    else if (posts[index]["comments_count"] == 1)
      return ("View " + posts[index]["comments_count"].toString() + " comment");
    else
      return ("View all " +
          posts[index]["comments_count"].toString() +
          " comments");
  }

  timeStamper(index) {
    final currentDate = DateTime.now();
    final postDate = DateTime.parse(posts[index]["created_at"]);
    final difference = currentDate.difference(postDate);
    String inHours = difference.inHours.toString();
    String inMin = difference.inMinutes.toString();
    String inDays = difference.inDays.toString();
    if (difference.inMinutes < 60) {
      if (difference.inMinutes <= 1) return inMin + " MINUTE AGO";
      return inMin + " MINUTES AGO";
    } else if (difference.inHours < 24) {
      if (difference.inHours <= 1) return inHours + " HOUR AGO";
      return inHours + " HOURS AGO";
    } else {
      if (difference.inDays <= 1) return inDays + " DAY AGO";
      return inDays + " DAYS AGO";
    }
  }

  int deterninePostLength() {
    refreshData(context);
    if (isUserPost == false && isMyPost == false) {
      postsCount = posts.length;
    } else if (isUserPost == true && isMyPost == false) {
      postsCount = userPosts.length;
    } else if (isUserPost == false && isMyPost == true) {
      postsCount = myPosts.length;
    }
    return postsCount;
  }

  void _showDialog(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              //    contentPadding: EdgeInsets.only(bottom: 40, top: 100),
              title: Center(child: Text("This isn't my post.")),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
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
    //var deviceSize = MediaQuery.of(context).size;
    return RefreshIndicator(
        color: Colors.black,
        onRefresh: refreshList,
        key: refreshKey,
        child: ListView.builder(
          itemCount: deterninePostLength(),
          itemBuilder: (BuildContext context, int index) {
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
                          InkWell(
                            child: Text(
                              posts[index]["user_email"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              userid = posts[index]["user_id"];
                              if (userid == myid) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstaMyProfile(myPosts)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstaUserProfile(userid)));
                              }
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
                InkWell(
                    onDoubleTap: () {
                      var id = posts[index]["id"];
                      likeButtonTriggerPost(index, id);
                      refreshData(context);
                    },
                    //enableFeedback: true,
                    child: Image.network(
                      checkValidImage(index),
                      fit: BoxFit.cover,
                      height: 400,
                      width: 450,
                    )),
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
                              onPressed: () {
                                var id = posts[index]["id"];
                                likeButtonTriggerPost(index, id);
                                refreshData(context);
                                refreshList();
                              }),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.commentDots),
                              onPressed: () {
                                refreshData(context);
                                var id = posts[index]["id"];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstaComments(posts, index, id)));
                              },
                            ),
                          ),
                          // IconButton(
                          // onPressed: (){

                          // },
                          // icon: Icon(FontAwesomeIcons.paperPlane),
                          // )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: () {
                              if (isMyPost == true){
                              var id = posts[index]["id"];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InstaEditPost(id)));
                              }
                              else
                              {
                                _showDialog(index);
                              }
                            },
                          ))
                    ],
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: checkNumLikes(index),
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: posts[index]["user_email"] + " ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          TextSpan(
                              text: posts[index]["caption"],
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    onTap: () {
                      var id = posts[index]["user_id"];
                      if (id == myid) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstaMyProfile(myPosts)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InstaUserProfile(id)));
                      }
                    },
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 5, left: 16),
                    child: GestureDetector(
                      onTap: () {
                        refreshData(context);
                        var id = posts[index]["id"];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InstaComments(posts, index, id)));
                      },
                      child: Text(checkNumComments(index),
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(timeStamper(index),
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                Divider(
                  height: 2.0,
                  indent: 1,
                ),
              ],
            );
          },
        ));
  }
}
