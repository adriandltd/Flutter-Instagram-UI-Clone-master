import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/insta_body.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'package:flutter_insta_clone/insta_myProfile.dart';
import 'package:flutter_insta_clone/insta_newPost.dart';

class InstaHome extends StatelessWidget {
  List<dynamic> posts;
  List<dynamic> myPosts;
  InstaHome(this.posts, this.myPosts);

  refreshDataHome(context) async {
    // var newPosts = await MyLoginPage().getPosts(savedToken);
    // var newMyPosts = await MyLoginPage().getPosts(savedToken);


    // this.posts = newPosts;
    // this.myPosts = newMyPosts;
    Navigator.push(context, PageRouteBuilder(
    pageBuilder: (context, anim1, anim2) => InstaHome(posts,myPosts),
    transitionsBuilder: (context, anim1, anim2, child) => Container(child: child),
    transitionDuration: Duration(seconds: 1)));
  }
  refreshDataProfile(context) async {
    var newPosts = await MyLoginPage().getPosts(savedToken);
    var newMyPosts = await MyLoginPage().getMyPosts(savedToken);
    
    this.posts = newPosts;
    this.myPosts = newMyPosts;
    Navigator.push(context, PageRouteBuilder(
    pageBuilder: (context, anim1, anim2) => InstaHome(newPosts,newMyPosts),
    transitionsBuilder: (context, anim1, anim2, child) => Container(child: child),
    transitionDuration: Duration(seconds: 1)));
  }


  final topBar = AppBar(
    backgroundColor: Color(0xfff8faf8),
    centerTitle: true,
    elevation: .5,
    leading: Container(),
    title: SizedBox(
        height: 42.0, child: Image.asset("assets/images/insta_logo.png")),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
     //   child: Icon(Icons.send),
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
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InstaNewPost()));

                  },
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
                  onPressed: () async{
                  //  refreshDataProfile(context);
                   // InstaMyProfile().getData(savedToken);
                  
                  Future.delayed(Duration(seconds:10));
                  CircularProgressIndicator();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InstaMyProfile(myPosts)));

                  }
                ),
              ],
            ),
          ),
        ));
  }
}
