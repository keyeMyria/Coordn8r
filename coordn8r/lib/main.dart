import 'package:coordn8r/login_page.dart';
import 'package:flutter/material.dart';

import 'package:coordn8r/pages/teams_page.dart';
import 'package:coordn8r/pages/home_page.dart';

// TODO: add flutter's simple_permissions to access internet, location, etc.

void main() => runApp(new Coordn8rApp());

class Coordn8rApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage()
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coordn8r',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.orange,
        accentColor: Colors.orangeAccent,
        splashColor: Colors.orangeAccent,
        buttonColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
//        inputDecorationTheme: InputDecorationTheme(
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(5.0),
//          ),
//        ),
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
