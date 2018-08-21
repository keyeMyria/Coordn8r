import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:coordn8r/pages/home_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static String tag = '/sign_up_page';

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = new GlobalKey<FormState>();
  static String firstNameSignUp;
  static String lastNameSignUp;
  String _email;
  String _password1;
  String _password2;
  String _errorTextEmail;
  String _errorTextPassword;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _signUpInProgress = false;

  @override
  void initState() {
    super.initState();
  }

  void _validateSignUp() async {
    final form = _signUpFormKey.currentState;
    if (form.validate()) {
      form.save();
      _finishSignUp();
    }
  }

  void _finishSignUp() {
    setState(() {
      _signUpInProgress = true;
      _errorTextEmail = null;
      _errorTextPassword =
          _password1 != _password2 ? 'Passwords do not match' : null;
    });

    if (_password1 != _password2) return;

    auth
        .createUserWithEmailAndPassword(email: _email, password: _password1)
        .catchError((err) {
      var errorMessage = err.message;
      setState(() {
        if (errorMessage.contains('email'))
          _errorTextEmail = errorMessage;
        else
          _errorTextPassword = errorMessage;
        _signUpInProgress = false;
      });
      return;
    }).then((newUser) {
      Firestore.instance.collection('users').document(newUser.uid).setData({
        'First Name': firstNameSignUp,
        'Last Name': lastNameSignUp,
      }); // creates new instance in firestore
      Firestore.instance
          .collection('users')
          .document(newUser.uid)
          .collection('objectives')
          .document()
          .setData({
        'Title': 'This is your first objective!',
        'Description':
            'On this page you will find all of your objectives. To the left '
            'is the status of the objective with 3 stages: not started, in '
            'progress, and complete.',
        'Status': 1,
        'Team': 'The Coordn8r Team',
        'Deadline':
            DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
      });
      user = newUser;

      auth
          .updateProfile(new UserUpdateInfo()
            ..displayName = firstNameSignUp + ' ' + lastNameSignUp)
          .then((_) {
        setState(() {
          _signUpInProgress = false;
        });

        Navigator.of(context).pushReplacementNamed(HomePage.tag);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: Center(
        child: ListView(
          primary: false, // does not try to scroll if page is not filled
          shrinkWrap: true,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage("assets/logo/logo96.png"),
                height: 96.0,
                width: 96.0,
              ),
            ),
            Form(
              key: _signUpFormKey,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              hintText: 'Jane',
                            ),
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            validator: (value) => value.isEmpty
                                ? 'Please enter your first name'
                                : null,
                            onSaved: (value) => firstNameSignUp = value,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          // must have this to not produce error
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              hintText: 'Doe',
                            ),
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            validator: (value) => value.isEmpty
                                ? 'Please enter your last name'
                                : null,
                            onSaved: (value) => lastNameSignUp = value,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "jane.doe@example.com",
                        errorText: _errorTextEmail,
                      ),
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
                        errorText: _errorTextPassword,
                        suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Icon(
                            _obscureText1
                                ? CommunityMaterialIcons.eye_off
                                : CommunityMaterialIcons.eye,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              _obscureText1 = !_obscureText1;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText1,
                      autofocus: false,
                      validator: (value) => value.length < 6
                          ? 'Password must be 6 characters'
                          : null,
                      onSaved: (val) => _password1 = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        errorText: _errorTextPassword,
                        suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Icon(
                            _obscureText2
                                ? CommunityMaterialIcons.eye_off
                                : CommunityMaterialIcons.eye,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText2,
                      autofocus: false,
                      validator: (value) => value.length < 6
                          ? 'Password must be 6 characters'
                          : null,
                      onSaved: (val) => _password2 = val,
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
                          _validateSignUp();
                        },
                        color: Theme.of(context).buttonColor,
                        child: _signUpInProgress
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).textTheme.button.color),
                              )
                            : Text(
                                "Create Account",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  constraints: BoxConstraints.tightFor(width: 60.0),
                  child: FlatButton(
                    padding: const EdgeInsets.all(0.0),
                    splashColor: Colors.grey,
                    child: Text(
                      "Log in",
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
