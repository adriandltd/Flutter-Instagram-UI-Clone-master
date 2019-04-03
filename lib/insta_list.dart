import 'package:flutter_insta_clone/insta_comments.dart';
import 'package:flutter_insta_clone/insta_userProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class InstaList extends StatefulWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaList(this.posts);
  @override
  _InstaList createState() => new _InstaList(this.posts);
}

class _InstaList extends State<InstaList> {
  List<dynamic> posts;
  List<dynamic> myPosts;
  List<dynamic> userPosts;
  int postsCount;
  _InstaList(this.posts);

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

  Future<List<dynamic>> getUserPosts(index,id) async {
    var token = savedToken;
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/users/$id/posts";

    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("Response status: ${response.statusCode}");
    print(jsonDecode(response.body).length);
    return jsonDecode(response.body);
  }

  refreshData(context) async {
    var newPosts = await MyLoginPage().getPosts(savedToken);
    var newmyPosts = await MyLoginPage().getMyPosts(savedToken);

    setState(() {
      this.posts = newPosts;
      this.myPosts = newmyPosts;
      _InstaList(this.posts).build(context);
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

  postComment(index){



  }


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
                          InkWell(child: Text(
                            posts[index]["user_email"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            
                          ),onTap: () {
                            //this is the video I was looking at: https://www.youtube.com/watch?v=EwHMSxSWIvQ
                            var id = posts[index]["id"];
                            FutureBuilder(
                              future: getUserPosts(index, id),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.data == null)
                                {
                                  return Container(
                                    child: Center(
                                      child: Text("Loading...")
                                    ),
                                  );
                                }
                                else{
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return ListTile(
                                      title: Text(snapshot.data[index]["title"]),
                                    );
                                  },
                                );                                }
                              },
                            );
                          },),
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
                              onPressed: () {
                                var id = posts[index]["id"];
                                likeButtonTriggerPost(index, id);
                                refreshData(context);
                              }),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            FontAwesomeIcons.comment,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          IconButton(
                          onPressed: (){

                          },
                          icon: Icon(FontAwesomeIcons.paperPlane,),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5),
                    child: GestureDetector(
                      onTap: (){
                        refreshData(context);
                        var id = posts[index]["id"];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InstaComments(posts, index, id)));
                        },
                      child: Text(checkNumComments(index), style: TextStyle(color: Colors.grey, fontSize: 14)),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 8.0),
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
}
