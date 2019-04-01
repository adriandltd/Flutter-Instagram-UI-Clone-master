import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class InstaComments extends StatefulWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  int postindex;
  int postsCount;
  InstaComments(this.posts, this.myPosts, this.postindex,this.postsCount);
  @override
  _InstaComments createState() => new _InstaComments(this.posts, this.myPosts, this.postindex, this.postsCount);
}

class _InstaComments extends State<InstaComments> {
  List<dynamic> posts;
  List<dynamic> myPosts;
  int postindex;
  var commentsList;
  int postsCount;
  int commentsCount;
  String comment;
  _InstaComments(this.posts, this.myPosts, this.postindex,this.postsCount);

  @override
  void initState() {
    super.initState();
      getComments((postindex+(postsCount-(postindex * 2))));
  }

  getComments(postindex) async {
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/posts/$postindex/comments";
    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
    var _commentsList = jsonDecode(response.body);
    setState(() {
      commentsList = _commentsList;
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
          title: Text("Comments", textAlign: TextAlign.left),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.send),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: commentsCount = posts[postindex]["comments_count"],
          itemBuilder: (BuildContext context, int commentindex) {
            getComments((postindex+(postsCount-(postindex * 2))));
            //commentsList.add(comment);
            //getCommentsList((postindex+(postsCount-(postindex * 2))), commentindex);
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
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                    TextSpan(text: "",style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: commentsList[commentindex]["text"])//getComments((postindex+(postsCount-(postindex * 2))), commentindex)),)
                                  ]))),
                        ],
                      ))
                ]);
          },
        ));
  }
}
