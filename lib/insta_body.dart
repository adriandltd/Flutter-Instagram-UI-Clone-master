import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_list.dart';

class InstaBody extends StatelessWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaBody(this.posts);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Flexible(child: InstaList(posts,myPosts,false))
      ],
    );
  }
}
