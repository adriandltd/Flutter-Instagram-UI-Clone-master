import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstaComments extends StatelessWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaComments(this.posts, this.myPosts);

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
    );
  }
}
