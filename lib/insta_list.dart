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
  List<dynamic> posts;
  List<dynamic> myPosts;
  bool isUserPost;
  InstaList(this.posts,this.myPosts,this.isUserPost);
  @override
  _InstaList createState() {
    if(isUserPost== true){
      return new _InstaList(this.myPosts,true);
    }
    else{
      return new _InstaList(this.posts,false);
    }
  }

}

class _InstaList extends State<InstaList> {
  List<dynamic> posts;
  List<dynamic> myPosts;
  bool isUserPost;
  List<dynamic> userPosts;
  int postsCount;

  _InstaList(this.posts,this.isUserPost);

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
    print("Response status: ${response.statusCode}");
    print(jsonDecode(response.body).length);
    return jsonDecode(response.body);
  }

  refreshData(context) async {
    var newPosts = await MyLoginPage().getPosts(savedToken);
    var newmyPosts = await MyLoginPage().getMyPosts(savedToken);

    setState(() {
      if(isUserPost==false){
        this.posts = newPosts;
        this.myPosts = newmyPosts;
        _InstaList(this.posts,false).build(context);}
      else{
        this.posts = newmyPosts;
        this.myPosts = newmyPosts;
        _InstaList(this.myPosts,true).build(context);
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
      return " ";
    else if (posts[index]["likes_count"] == 1)
      return (posts[index]["likes_count"].toString() + " like");
    else
      return (posts[index]["likes_count"].toString() + " likes");
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
          itemCount: postsCount = posts.length,
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
                              var id = posts[index]["user_id"];
                              if (id == myid )
                              {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InstaMyProfile(myPosts)));

                              }
                              else
                              {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InstaUserProfile(id)));
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
                          child: IconButton(icon: Icon(Icons.info_outline),
                          onPressed: (){
                            var id = posts[index]["id"];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstaEditPost(id)));
                          },))
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
                              if (id == myid )
                              {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InstaMyProfile(myPosts)));

                              }
                              else
                              {
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
