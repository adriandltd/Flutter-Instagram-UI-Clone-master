import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_body.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:flutter_insta_clone/insta_userprofile.dart';

class InstaHome extends StatelessWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaHome(this.posts);

  refreshDataHome(context) async {
    var newPosts = await MyLoginPage().getPosts(savedToken);

    this.posts = newPosts;
    Navigator.push(context, PageRouteBuilder(
    pageBuilder: (context, anim1, anim2) => InstaHome(newPosts),
    transitionsBuilder: (context, anim1, anim2, child) => Container(child: child),
    transitionDuration: Duration(seconds: 1)));
  }
  refreshDataProfile(context) async {
    var newmyPosts = await MyLoginPage().getMyPosts(savedToken);

    this.myPosts = newmyPosts;
    Navigator.push(context, PageRouteBuilder(
    pageBuilder: (context, anim1, anim2) => InstaHome(newmyPosts),
    transitionsBuilder: (context, anim1, anim2, child) => Container(child: child),
    transitionDuration: Duration(seconds: 1)));
  }

  final topBar = AppBar(
    backgroundColor: Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    leading: Icon(Icons.camera_alt),
    title: SizedBox(
        height: 35.0, child: Image.asset("assets/images/insta_logo.png")),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(Icons.send),
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: topBar,
        body: InstaBody(posts),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 73.0,
          alignment: Alignment.center,
          child: BottomAppBar(
            child: Row(
              // alignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.home,
                  ),
                  onPressed: () {
                    refreshDataHome(context);
                    },
                    ),
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.add_box,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.favorite,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.account_box,
                  ),
                  onPressed: (){
                    refreshDataProfile(context);
                  }
                ),
              ],
            ),
          ),
        ));
  }
}
