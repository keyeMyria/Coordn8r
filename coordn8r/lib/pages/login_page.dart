import 'dart:async';

import 'package:coordn8r/pages/email_confirmation_page.dart';
import 'package:coordn8r/pages/forgot_password_page.dart';
import 'package:coordn8r/pages/home_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:coordn8r/pages/sign_up_page.dart';

// final GoogleSignIn _googleSignIn = new GoogleSignIn();

class LoginPage extends StatefulWidget {
  static final String tag = '/login_page';

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorText;
  bool _loginInProgress = false; // TODO: Move to a stream

  @override
  void initState() {
    super.initState();
    _logout();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _iconAnimation = Tween(begin: 0.0, end: 100.0)
        .animate(_iconAnimationController)
          ..addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  void _testSignIn() {
    final form = _loginFormKey.currentState;
    if (form.validate()) {
      form.save();
      _login();
    }
  }

  void _login() async {
    setState(() {
      _loginInProgress = true;
    });
    await auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((FirebaseUser u) {
      if (u != null && !u.isAnonymous && u.getIdToken() != null) {
        user = u;
        _loginInProgress = false;
//        if (!u.isEmailVerified)
//          Navigator.of(context).pushNamed(EmailConfirmationPage.tag);
//        else
        Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (context, animation, _) => HomePage(),
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, _, child) =>
                  FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
            ));
      } else {
        setState(() {
          _loginInProgress = false;
          _errorText = 'Invalid email and password combination';
        });
      }
    }).catchError((e) => setState(() {
              print('ERROR: ' + e.toString());
              _loginInProgress = false;
              _errorText = 'Error experienced with server';
            }));

//    assert(user != null);
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
//    assert(user.isEmailVerified); TODO: implement this when signup is implemented
  }

  void _logout() async {
    // TODO: delete underscore to make public method
    await auth.signOut().catchError((e) => print(e
        .message)); // TODO: define what happens when the logout is unsuccessful
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          primary: false,
          shrinkWrap: true, // this plus "Center" centers everything
          children: <Widget>[
            InkWell(
                child: Hero(
                  tag: 'logo',
                  child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/logo/logo96.png"),
                    height: 96.0,
                    width: 96.0,
                  ),
                ),
                onTap: () {
                  _email = "quintonhoffman22@gmail.com";
                  _password = "TestPassword";
                  _login();
                }),
            Form(
              key: _loginFormKey,
              child: Container(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Email", hintText: "jane.doe@example.com"),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      validator: (value) =>
                          value.isEmpty || !value.contains('@')
                              ? 'Please enter valid email'
                              : null,
                      onSaved: (val) => _email = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        errorText: _errorText,
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      autofocus: false,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter valid password' : null,
                      onSaved: (val) => _password = val,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(30.0),
                      child: MaterialButton(
                        minWidth: 200.0,
                        height: 50.0,
                        onPressed: _loginInProgress ? null : _testSignIn,
                        color: Theme.of(context).buttonColor,
                        child: _loginInProgress
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).textTheme.button.color),
                              )
                            : Text(
                                "Log In",
                                style: Theme.of(context).textTheme.button,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          splashColor: Colors.grey,
                          child: Text("Sign up"),
                          onPressed: () =>
                              Navigator.of(context).pushNamed(SignUpPage.tag),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        FlatButton(
                          splashColor: Colors.grey,
                          onPressed: () => Navigator
                              .of(context)
                              .pushNamed(ForgotPasswordPage.tag),
                          child: Text("Forgot Password"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
