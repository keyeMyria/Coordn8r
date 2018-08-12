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
  static final String tag = "/pre_login_page";

  @override
  State<PreLoginPage> createState() => PreLoginPageState();
}

class PreLoginPageState extends State<PreLoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  Duration _duration = Duration(milliseconds: 1000);
  CurvedAnimation _easeOutAnimation;

  @override
  void initState() {
    super.initState();

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _easeOutAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeOut,
    );

    _iconAnimation = Tween(begin: 0.5, end: 1.0).animate(_easeOutAnimation)
      ..addListener(() => this.setState(() {}));

    _iconAnimationController.forward();
    Timer(
        _duration,
        () => _checkLoginStatus()
            .then((loginStatus) => loginStatus ? _goHome() : _goLogin()));

    // do animation
    // once finished
  }

  Future<bool> _checkLoginStatus() async {
    user = await auth.currentUser();
    return user != null;
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, _) => HomePage(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, _, child) => FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(animation),
                child: child,
              ),
        ));
  }

  void _goLogin() {
    Navigator.of(context).pushReplacementNamed(LoginPage.tag);
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
