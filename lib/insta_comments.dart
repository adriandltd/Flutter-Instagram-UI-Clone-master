import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class InstaComments extends StatefulWidget {
  List<dynamic> posts;
  int postindex;
  int postid;
  InstaComments(this.posts, this.postindex, this.postid);
  @override
  _InstaComments createState() =>
      new _InstaComments(this.posts, this.postindex, this.postid);
}

class _InstaComments extends State<InstaComments> {
  List<dynamic> posts;
  int postindex;
  int postid;
  int commentid;
  var commentsList;
  int commentsCount;
  var commentCtrl = TextEditingController();
  _InstaComments(this.posts, this.postindex, this.postid);

  @override
  void initState() {
    super.initState();
    getComments(postid);
  }

  getComments(postid) async {
    var url =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/$postid/comments";
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
    var _commentsList = jsonDecode(response.body);
    setState(() {
      commentsList = _commentsList;
    });
  }

  postComment(postid) async {
    var comment = commentCtrl.text;
    var url =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/$postid/comments?text=$comment";
    http.post(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
  }

  deleteComment(commentid) async {
    var url =
        "https://serene-beach-48273.herokuapp.com//api/v1/comments/$commentid";
    http.delete(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
  }

  determineifusercomment(commentindex) {
    if (commentsList[commentindex]["belongs_to_current_user"] == true) {
      return IconButton(
        icon: Icon(FontAwesomeIcons.trash),
        onPressed: () {
          commentid = commentsList[commentindex]["id"];
          deleteComment(commentid);
          getComments(postid);
        },
      );
    } else {
      return null;
    }
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
        title: Text("Comments", textAlign: TextAlign.left),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.send),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: commentsCount = posts[postindex]["comments_count"],
              itemBuilder: (BuildContext context, int commentindex) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 7.0),
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
                                      image: NetworkImage(
                                          commentsList[commentindex]["user"]
                                              ["profile_image_url"])),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: commentsList[commentindex]
                                                        ["user"]["email"] +
                                                    " ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: commentsList[commentindex]
                                                    ["text"])
                                          ]))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(),
                                    child: determineifusercomment(commentindex),
                                  )
                                ],
                              ),
                            ],
                          )),
                    ]);
              },
            ),
          ),
          Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 5.0),
              child: TextField(
                controller: commentCtrl,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add a comment...",
                ),
              ),
            ),
          ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.commentDots),
        mini: true,
        onPressed: () {
          setState(() {
            postComment(postid);
            getComments(postid);
          });
        },
      ),
    );
  }
}
