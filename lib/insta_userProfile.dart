import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstaUserProfile extends StatefulWidget {
  List<dynamic> userPosts;

  InstaUserProfile(this.userPosts);
  @override
  _InstaUserProfile createState() => new _InstaUserProfile(this.userPosts);
}

class _InstaUserProfile extends State<InstaUserProfile> {
  List<dynamic> userPosts;
  _InstaUserProfile(this.userPosts);

  int postsCount;


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
          title: Text("Profile", textAlign: TextAlign.left),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.send),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: userPosts.length,
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
                                    TextSpan(text: userPosts[index]["caption"])
                                  ]))),
                        ],
                      ))
                ]);
          },
        ));
  }
}
