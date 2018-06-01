import 'package:coordn8r/pages/home_page.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login_page';

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() => {}));
    _iconAnimationController.forward();
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
                        labelText: "Email", hintText: "john.doe@example.com"),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    validator: (value) {
                      // could possibly do some frontend verification to make sure email is valid
                      // but will leave the validation to the backend
                      if (value.isEmpty) return 'Please enter valid email';
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      //errorText: "I am error text",
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter valid password';
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      minWidth: 200.0,
                      height: 50.0,
                      onPressed: () {
                        if (_loginFormKey.currentState.validate()) {
                          // TODO: implement animation
                          Navigator.of(context).pushNamed(HomePage.tag);
                        }
                      },
                      color: Colors.orange,
                      child: Text("Log In"),
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
