import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_insta_clone/insta_login.dart';
import 'dart:io';
import 'package:dio/dio.dart';

void main() => runApp(new MyApp());

//comment added at 9:48 PM on 3/20/2019

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(color: Colors.black),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
          textTheme: TextTheme(title: TextStyle(color: Colors.black))),
      home: MyLoginPage(),
    );
  }
}
