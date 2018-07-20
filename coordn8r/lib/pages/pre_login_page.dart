import 'package:flutter/material.dart';
import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;

class PreLoginPage extends StatefulWidget {
  static String tag = "/pre_login_page";

  @override
  State<PreLoginPage> createState() => PreLoginPageState();
}

class PreLoginPageState extends State<PreLoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _iconAnimation =
        Tween(begin: 0.5, end: 1.0).animate(_iconAnimationController)
          ..addListener(() => this.setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              setState(() {});
            } else if (status == AnimationStatus.completed) {
              setState(() {
                _checkLoginStatus().then((loginStatus) =>
                    _go(loginStatus ? HomePage.tag : LoginPage.tag));
              });
            }
          });

    _iconAnimationController.forward();

    // do animation
    // once finished
  }

  Future<bool> _checkLoginStatus() async {
    user = await auth.currentUser();
    return user != null;
  }

  void _go(tag) {
    Navigator.of(context).pushReplacementNamed(tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Image(
                image: AssetImage("assets/logo/logo96.png"),
                height: _iconAnimation.value * 96,
                width: _iconAnimation.value * 96,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
