import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class InstaWhoLiked extends StatefulWidget {
  List<dynamic> posts;
  int postindex;
  int postid;
  InstaWhoLiked(this.posts, this.postindex, this.postid);
  @override
  _InstaWhoLiked createState() =>
      new _InstaWhoLiked(this.posts, this.postindex, this.postid);
}

class _InstaWhoLiked extends State<InstaWhoLiked> {
  List<dynamic> posts;
  int postindex;
  int postid;
  int commentid;
  var likedList;
  int commentsCount;
  var commentCtrl = TextEditingController();
  var editCommentCtrl = TextEditingController();
  bool _btnEnabled = false;
  _InstaWhoLiked(this.posts, this.postindex, this.postid);

  @override
  void initState() {
    super.initState();
    getWhoLiked(postid);
  }

  getWhoLiked(postid) async {
    var url =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/$postid/likes";
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $savedToken"});
    var _likedList = jsonDecode(response.body);
    setState(() {
      likedList = _likedList;
    });
  }

  determineifusercomment(commentindex) {
    if (likedList[commentindex]["belongs_to_current_user"] == true) {
      return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: MaterialButton(
          child: Text("Delete comment"),
          onPressed: () {
            commentid = likedList[commentindex]["id"];
            getWhoLiked(postid);
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      return Text("Nothing to see here.");
    }
  }

  determineifusercomment2(commentindex) {
    if (likedList[commentindex]["belongs_to_current_user"] == true) {
      return Column(
        children: <Widget>[
            Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: TextField(
                            controller: editCommentCtrl,
                            decoration: InputDecoration(
                              hintText: "New comment...",
                            border: OutlineInputBorder(),
                            //EdgeInsets.only(left: 15, top: 30, right: 40),
                      ))),
                    ],
                  ),
                                    Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: MaterialButton(
              //  padding: const EdgeInsets.symmetric(),
              child: Text("Edit comment"),
            onPressed: (){
            setState(() {
            commentid = likedList[commentindex]["id"];
            getWhoLiked(postid);
            Navigator.of(context).pop();
            });
            })
          ),
        ],
      );
    }
    else {
      return null;
    }
  }

  timeStamper(commentindex) {
    final currentDate = DateTime.now();
    final postDate = DateTime.parse(likedList[commentindex]["created_at"]);
    final difference = currentDate.difference(postDate);
    String inHours = difference.inHours.toString();
    String inMin = difference.inMinutes.toString();
    String inDays = difference.inDays.toString();
    if (difference.inMinutes < 60) {
      if (difference.inMinutes <= 1) return inMin + " m";
      return inMin + " m";
    } else if (difference.inHours < 24) {
      if (difference.inHours <= 1) return inHours + " h";
      return inHours + " h";
    } else {
      if (difference.inDays <= 1) return inDays + " d";
      return inDays + " d";
    }
  }

  void _showDialog(commentindex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            //    contentPadding: EdgeInsets.only(bottom: 40, top: 100),
            title: Text("Please select an option:"),
            content: Container(
              //  padding: EdgeInsets.only(bottom: 10, top: 40, left: 40, right: 40),
              child: (Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                           Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                      Container(
                        child: determineifusercomment2(commentindex)
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                   //   Container(child: Text("Delete comment")),
                      Container(
                        //  padding: const EdgeInsets.symmetric(),
                        child: determineifusercomment(commentindex),
                      ),
                    ],
                  )
                ],
              )),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
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
          text: "Comments",
          )]
        )),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
          //    child: Icon(Icons.send),
            )
          ],
        ),
        body: Column(children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
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
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 2.0),
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
                                  image: NetworkImage(likedList[commentindex]
                                      ["user"]["profile_image_url"])),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  //padding: const EdgeInsets.only(
                                  //  bottom: 20, left: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 15),
                                    child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: likedList[commentindex]
                                                        ["user"]["email"] +
                                                    " ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: likedList[commentindex]
                                                    ["text"]),
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showDialog(commentindex);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 215),
                      child: Column(children: <Widget>[
                        Text(timeStamper(commentindex),
                            style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ]),
                    )
                  ],
                );
              },
            ),
          ),
          Divider(height: 45.0),
          Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              //      crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                    width: 330,
                    child: TextField(
                      //       autofocus: true,
                      onChanged: (commentCtrl) {
                        if (commentCtrl.length >= 1) {
                          setState(() {
                            _btnEnabled = true;
                          });
                        } else {
                          setState(() {
                            _btnEnabled = false;
                          });
                        }
                      },
                      controller: commentCtrl,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15, top: 30),
                        hintText: "Add a comment...",
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(.4)),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(45))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(45))),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    top: 2,
                    child: MaterialButton(
                      child: RichText(
                          text: TextSpan(
                              text: "Post",
                              style: TextStyle(
                                color: Colors.lightBlue.withOpacity(1),
                                fontWeight: FontWeight.w600,
                              ))),
                      onPressed: () {
                            setState(() {
                                getWhoLiked(postid);
                              });
                      },
                    ),
                  )
                ])
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
          )
        ]));
  }
}
