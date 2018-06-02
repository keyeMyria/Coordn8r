import 'package:coordn8r/pages/home_page.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class LoginPage extends StatefulWidget {
  static String tag = 'login_page';

  //final firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

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
  bool _loginInProgress = false;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    )..addListener(() => this.setState(() => {}));
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

  Future<FirebaseUser> _login() async {
    setState(() {
      _loginInProgress = true;
    });
    await _auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((FirebaseUser user) async => (user != null &&
                !user.isAnonymous &&
                await user.getIdToken() != null)
            ? Navigator.of(context).pushNamed(HomePage.tag)
            : setState(() {
                _loginInProgress = false;
                _errorText = 'Invalid email and password combination';
              }))
        .catchError((e) => setState(() {
              _loginInProgress = false;
              _errorText = 'Invalid email and password combination';
            }));

//    assert(user != null);
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
//    assert(user.isEmailVerified); TODO: implement this when signup is implemented
  }

  bool _logout() {
    bool _success = false;

    return _success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlutterLogo(
            size: _iconAnimation.value * 100,
          ),
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
                    validator: (value) => value.isEmpty || !value.contains('@')
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
                      color: Colors.orange,
                      child: _loginInProgress
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).textTheme.display1.color),
                            )
                          : Text("Log In"),
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
                        onPressed: () {
                          // TODO: implement sign up
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      FlatButton(
                        splashColor: Colors.grey,
                        onPressed: () {
                          // TODO: implement forgot password
                        },
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
    );
  }
}
