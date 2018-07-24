import 'dart:async';
import 'dart:io';
import 'package:coordn8r/pages/email_confirmation_page.dart';
import 'package:coordn8r/pages/forgot_password_page.dart';
import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:coordn8r/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO: add flutter's simple_permissions to access internet, location, etc.

void main() => runApp(new Coordn8rApp());

class Coordn8rApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    PreLoginPage.tag: (context) => PreLoginPage(),
    SignUpPage.tag: (context) => SignUpPage(),
    EmailConfirmationPage.tag: (context) => EmailConfirmationPage(),
    ForgotPasswordPage.tag: (context) => ForgotPasswordPage(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color gray = Color(0xFF707070);
    const Color lightBlue = Color(0xFF8FD8FF);
    const Color midBlue = Color(0xFF599CC0);
    const Color darkBlue = Color(0xFF2A5A74);
    const Color gold = Color(0xFFC07A1F);
    const Color brown = Color(0xFF74542A);

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

          // Gray: 0xFF707070
          // Light Blue: 0xFF8FD8FF
          // Mid Blue: 0xFF599CC0
          // Dark Blue: 0xFF2A5A74
          // Gold: 0xFFC07A1F
          // Brown: 0xFF74542A

          primaryColor: darkBlue,
          accentColor: lightBlue,
          splashColor: darkBlue,
          buttonColor: midBlue,
          iconTheme: IconThemeData(color: gold),
          accentIconTheme: IconThemeData(color: brown),
          scaffoldBackgroundColor: Colors.white,
          indicatorColor: gold,
          errorColor: Colors.red,
          dividerColor: gray,
          textTheme: new TextTheme(
            button: TextStyle(
              color: Colors.white,
            ),
          )

//        inputDecorationTheme: InputDecorationTheme(
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(5.0),
//          ),
//        ),
          ),
      home: PreLoginPage(),
      routes: routes,
    );
  }
}

// For creating futures use:
// new Future<bool>.value(true)
