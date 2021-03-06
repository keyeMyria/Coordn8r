import 'package:coordn8r/pages/forgot_password_page.dart';
import 'package:coordn8r/pages/home_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coordn8r/pages/sign_up_page.dart';

// final GoogleSignIn _googleSignIn = new GoogleSignIn();

class LoginPage extends StatefulWidget {
  static final String tag = '/login_page';

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _iconAnimationController;
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorText;
  bool _loginInProgress = false; // TODO: Move to a stream
  final double _percentHeightSpacing = 0.05;
  final double _percentWidthSpacing = 0.1;
  final double _loginButtonHeight = 50.0;
  final double _loginButtonMinWidth = 100.0;

  @override
  void initState() {
    super.initState();
    _logout();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
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
      _errorText = null;
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
              _errorText = 'Invalid email and password combination';
            }));

//    assert(user != null);
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
//    assert(user.isEmailVerified); TODO: implement this when signup is implemented
  }

  void _logout() async {
    await auth.signOut().catchError((e) => print(e
        .message)); // TODO: define what happens when the logout is unsuccessful
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    Widget boxSpacing = SizedBox(height: screenHeight * _percentHeightSpacing);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * _percentWidthSpacing),
          child: Form(
            key: _loginFormKey,
            child: ListView(
              primary: false,
              shrinkWrap: true, // this plus "Center" centers everything
              children: <Widget>[
                InkWell(
                    // TODO: REMOVE LATER
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
                      _password = "111111";
                      _login();
                    }),
                boxSpacing,
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
                boxSpacing,
                Padding(
                  padding: EdgeInsets.symmetric(
                      // basically a lot of code to make sure the min width is 100
                      horizontal: screenWidth * (1 - 2 * _percentWidthSpacing) -
                                  (screenWidth * 2 * 0.15) <
                              _loginButtonMinWidth
                          ? (-_loginButtonMinWidth +
                                  screenWidth *
                                      (1 - 2 * _percentWidthSpacing)) /
                              2
                          : screenWidth * 0.15),
                  child: Material(
                    borderRadius: BorderRadius.circular(_loginButtonHeight / 2),
                    child: MaterialButton(
                      height: _loginButtonHeight,
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
                ),
                boxSpacing,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      splashColor: Colors.grey,
                      child: Text("Sign up"),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(SignUpPage.tag),
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
      ),
    );
  }
}
