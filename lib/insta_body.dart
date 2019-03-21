import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_list.dart';

class InstaBody extends StatelessWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaBody(this.posts, this.myPosts);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: InstaStories()),
        Flexible(child: InstaList(posts, myPosts))
      ],
    );
  }
}
