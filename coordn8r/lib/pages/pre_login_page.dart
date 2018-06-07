import 'package:flutter/material.dart';
import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;

class PreLoginPage extends StatefulWidget {
  static String tag = "pre_login_page";

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
        Tween(begin: 0.0, end: 100.0).animate(_iconAnimationController)
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
    Navigator.of(context).pushNamed(tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "Loading...",
            textAlign: TextAlign.center,
          ),
          height: _iconAnimation.value,
          width: _iconAnimation.value,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
