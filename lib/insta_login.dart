import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_insta_clone/insta_home.dart';

void main() => runApp(MyApp());

var savedToken;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatelessWidget {
  var userCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  void loginStuff(context) async {
    var token = await login();
    var allPosts = await getPosts(token);
    var myPosts = await getMyPosts(token);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => InstaHome(allPosts, myPosts)));
  }

  Future<String> login() async {
    var user = userCtrl.text;
    var pass = passCtrl.text;
    var url =
        "https://serene-beach-48273.herokuapp.com/api/login?username=$user&password=$pass";
    var response = await http.get(url);
    //var token = jsonDecode(response.body)["token"];
    var token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozNH0.kZDXUlZ1urAhJCfWHwzUBGD9qpjapjq2cke1cnTl2jE";
    savedToken = token;
    return token;
  }

  Future<List<dynamic>> getPosts(token) async {
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/posts";

    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getMyPosts(token) async {
    var url = "https://serene-beach-48273.herokuapp.com/api/v1/my_posts";

    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 205.0)),
              SizedBox(
                  height: 75.0,
                  child: Image.asset("assets/images/insta_logo.png")),
              Padding(padding: const EdgeInsets.only(top: 20.0)),
              Container(
                  width: 325,
                  child: TextField(
                    controller: userCtrl,
                    decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()),
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                  )),
              Padding(padding: const EdgeInsets.only(top: 15.0)),
              Container(
                  width: 325,
                  child: TextField(
                      keyboardType: TextInputType.number,
                      controller: passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password",
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder()))),
              Padding(padding: const EdgeInsets.only(top: 18.0)),
              ButtonTheme(
                  minWidth: 325.0,
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.blue,
                    child:
                        Text("Log In", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      loginStuff(context);
                    },
                  ))
            ],
          ),
        ],
      ),
    );
    return scaffold;
  }
}
